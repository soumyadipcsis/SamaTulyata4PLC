from collections import defaultdict, deque
from z3 import *

class PetriNet:
    def __init__(self):
        self.places = {}
        self.transitions = {}
        self.formulas = {}
        self.input_arcs = defaultdict(list)
        self.arcs = defaultdict(list)
        self.output_arcs = defaultdict(list)
        self.cutpoints = set()
        self.paths = []
        self.reset_state = None
        self.input_places = []

    def add_place(self, place, marking=0):
        self.places[place] = marking

    def add_transition(self, transition, formula=""):
        self.transitions[transition] = formula

    def add_formula(self, formula, content):
        self.formulas[formula] = content

    def add_input_arc(self, source, target):
        self.input_arcs[source].append(target)

    def add_arcs(self, source, target):
        self.arcs[source].append(target)

    def add_output_arc(self, source, target):
        self.output_arcs[source].append(target)

    def bfs(self, start):
        visited = set()
        queue = deque([start])
        while queue:
            node = queue.popleft()
            if node not in visited:
                print(node, end=" -> ")
                visited.add(node)
                for next_node in self.input_arcs[node] + self.arcs[node] + self.output_arcs[node]:
                    if next_node not in visited:
                        queue.append(next_node)
        print("End")

    def identify_cutpoints(self):
        for place in self.input_places:
            self.cutpoints.add(place)
        for place in self.places:
            outgoing_arcs = self.input_arcs[place]
            if len(outgoing_arcs) < 1:
                self.cutpoints.add(place)
        for place in self.places:
            outgoing_arcs = self.input_arcs[place]
            if len(outgoing_arcs) > 1:
                self.cutpoints.add(place)

        visited = set()
        stack = [self.reset_state]
        parent = {self.reset_state: None}
        entry_points = set()

        while stack:
            node = stack.pop()
            if node not in visited:
                visited.add(node)
                for next_node in self.input_arcs[node] + self.arcs[node] + self.output_arcs[node]:
                    if next_node not in visited:
                        parent[next_node] = node
                        stack.append(next_node)
                    elif next_node in visited and next_node != parent[node]:
                        entry_points.add(next_node)

        self.cutpoints.update(entry_points)

    def find_all_paths(self, start, end):
        def dfs(current, end, path, visited_places):
            if current in self.places:
                visited_places[current] += 1

            path.append(current)

            if current == end:
                paths.append(path.copy())
            else:
                next_nodes = self.input_arcs[current] + self.arcs[current] + self.output_arcs[current]
                for node in next_nodes:
                    if visited_places[node] < 2:
                        dfs(node, end, path, visited_places)

            path.pop()
            if current in self.places:
                visited_places[current] -= 1

        paths = []
        visited_places = defaultdict(int)
        dfs(start, end, [], visited_places)
        return paths

    def find_paths(self, start):
        def find_path_dfs(start, path, visited, cutpointlist):
            path.append(start)
            visited[start] += 1
            next_nodes = self.input_arcs[start] + self.arcs[start] + self.output_arcs[start]
            for node in next_nodes:
                if node in cutpointlist:
                    path.append(node)
                    paths.append(path.copy())
                    path.pop()
                elif visited[node] < 1:
                    find_path_dfs(node, path, visited, cutpointlist)
            path.pop()

        paths = []
        visited = defaultdict(int)
        cutpointlist = self.cutpoints
        find_path_dfs(start, [], visited, cutpointlist)
        return paths

    def extract_paths(self):
        self.identify_cutpoints()
        cutpoints_list = list(self.cutpoints)
        print("Cutpoints:", cutpoints_list)
        self.paths = []
        for i in range(len(cutpoints_list)):
            self.paths.extend(self.find_paths(cutpoints_list[i]))
        return self.paths

    def print_path_cover(self):
        paths = self.extract_paths()
        for path in paths:
            print(" -> ".join(path))


def check_path_equivalence(petri_net_0, petri_net_1):
    paths_0 = petri_net_0.extract_paths()
    paths_1 = petri_net_1.extract_paths()

    for path_0 in paths_0:
        # print("path in path0", path_0)
        found_equivalent = False
        for path_1 in paths_1:
            if check_equivalence(path_0, path_1, petri_net_0, petri_net_1):
                found_equivalent = True
                break
        if not found_equivalent:
            print(f"No equivalent path for {path_0} in petri_net_1")
            return False
    return True


def check_equivalence(path_0, path_1, petri_net_0, petri_net_1):
    if len(path_0) != len(path_1):
        return False
    print("path in path0", path_0)
    print("path in path1", path_1)
    s = Solver()
    transition_0 = []
    transition_1 = []
    formula_0 = []
    formula_1 = []

    for elem in path_0:
        if elem in petri_net_0.transitions:
            transition_0.append(petri_net_0.transitions[elem])
        if elem in petri_net_0.formulas:
            formula_0.append(petri_net_0.formulas[elem])

    for elem in path_1:
        if elem in petri_net_1.transitions:
            transition_1.append(petri_net_1.transitions[elem])
        if elem in petri_net_1.formulas:
            formula_1.append(petri_net_1.formulas[elem])
    print(transition_0,transition_1)
    if len(transition_0) != len(transition_1) or len(formula_0) != len(formula_1):
        return False

    for t0, t1 in zip(transition_0, transition_1):
        t0_expr = t0
        t1_expr = t1
        print(t0_expr,t1_expr)
        if not check_expression_equivalence(s, str(t0_expr), str(t1_expr)):
            print("*********The expressions are not equivalent. **************")
            return False

    for f0, f1 in zip(formula_0, formula_1):
        assignments_f0 = f0.split(',')
        assignments_f1 = f1.split(',')
        for exp0, exp1 in zip(assignments_f0, assignments_f1):
            exp0 = exp0.strip().replace('=', '==', 1)
            exp1 = exp1.strip().replace('=', '==', 1)
            if not check_expression_equivalence(s, str(exp0), str(exp1)):
                print("The expressions are not equivalent.")
                return False
    return True


def check_expression_equivalence(s, expr_0, expr_1):
    print(f"expresion 0:{expr_0},expression 1:{expr_1}")
    i = Int('i')
    l1 = Int('l1')
    x = Int('x')
    y = Int('y')
    z = Int('z')
    b = Int('b')
    l2 = Int('l2')
    c = Int('c')
    a = Int('a')
    j = Int('j')
    out = Int('out')
    h1 = Int('h1')
    h2 = Int('h2')
    s.push()
    s.add(eval(expr_0) != eval(expr_1))
    result = s.check()
    s.pop()
    print(result)
    return result == unsat
