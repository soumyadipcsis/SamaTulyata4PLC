from collections import defaultdict, deque
from z3 import *
class PetriNet:
    def __init__(self,reset_state):
        self.places = {}
        self.transitions = {}
        self.formulas = {}
        self.input_arcs = defaultdict(list)
        self.arcs = defaultdict(list)
        self.output_arcs = defaultdict(list)
        self.cutpoints = set()
        self.reset_state = reset_state
        self.paths = []  # Add paths attribute
        self.dummy_counter = 0

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
        for place in self.places:
            outgoing_arcs = self.input_arcs[place]
            if len(outgoing_arcs) > 1:
                self.cutpoints.add(place)

        # Add loop entry points (nodes with back edges)
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
                    elif next_node in visited and next_node != parent[node]:  # Detect back edge
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

    def extract_paths(self):
        self.identify_cutpoints()
        cutpoints_list = list(self.cutpoints)
        print("Cutpoints:", cutpoints_list)
        self.paths = []  # Use the class attribute paths
        place_keys = list(self.places.keys())  # Get the list of place keys
        print(f"Places Keys:{place_keys}")
        for i in range(len(place_keys)):
            for j in range(i+1 , len(place_keys)):
                if  place_keys[j] in cutpoints_list:
                    start = place_keys[0]
                    end = place_keys[j]
                    self.paths.extend(self.find_all_paths(start, end))
        return self.paths

    def print_path_cover(self):
        paths = self.extract_paths()
        for path in paths:
            print(" -> ".join(path))

def check_path_equivalence(petri_net_0, petri_net_1):
    paths_0 = petri_net_0.extract_paths()
    paths_1 = petri_net_1.extract_paths()

    for path_0 in paths_0:
        print("path in path0",path_0)
        found_equivalent = False
        for path_1 in paths_1:
            print("path in path1", path_1)
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
    s = Solver()
    transition_0 = []
    transition_1 = []
    formula_0 = []
    formula_1 = []

    # Collect transitions and formulas for path_0
    for elem in path_0:
        if elem in petri_net_0.transitions:
            transition_0.append(petri_net_0.transitions[elem])
        if elem in petri_net_0.formulas:
            formula_0.append(petri_net_0.formulas[elem])

    # Collect transitions and formulas for path_1
    for elem in path_1:
        if elem in petri_net_1.transitions:
            transition_1.append(petri_net_1.transitions[elem])
        if elem in petri_net_1.formulas:
            formula_1.append(petri_net_1.formulas[elem])
    # Check if the number of transitions and formulas match
    print(transition_0,transition_1,formula_0,formula_1)
    if len(transition_0) != len(transition_1) or len(formula_0) != len(formula_1):
        return False

    # Create Z3 variables used in the transition conditions
    i = Int('i')
    l1 = Int('l1')
    x = Int('x')
    y = Int('y')
    z = Int('z')
    b=Int('b')
    l2 = Int('l2')
    c = Int('c')
    a=Int('a')
    j=Int('j')
    out=Int('out')
    h1=Int('h1')
    # Add constraints to the solver for transitions and formulas
    for t0, t1 in zip(transition_0, transition_1):
        t0_expr = t0.split(": ")[1]
        t1_expr = t1.split(": ")[1]
        # Check equivalence using the check_expression_equivalence function

        if check_expression_equivalence(s, str(t0_expr), str(t1_expr)):
            print("The expressions are equivalent.")
        else:
            print("*********The expressions are not equivalent. **************")
            return False

    # Use Z3's built-in operators to create expressions from the formulas
    for f0, f1 in zip(formula_0, formula_1):
        assignments_f0 = f0.split(',')
        assignments_f1 = f1.split(',')
        # print("---**--",assignments_f0,assignments_f1)
        for exp0, exp1 in zip(assignments_f0, assignments_f1):
            exp0 = exp0.strip()
            exp1 = exp1.strip()
            # print(exp0," and ", exp1)
            if check_expression_equivalence(s, str(exp0), str(exp1)):
                print("The expressions are equivalent.")
            else:
                print("The expressions are not equivalent.")
                return False
    return True

def check_expression_equivalence(s, expr_0, expr_1):
    """Checks if two Z3 expressions are equivalent."""
    # Create Z3 variables used in the transition conditions
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
    s.push()  # Create a new context for the check
    print(expr_1,expr_0)
    s.add(eval(expr_0) != eval(expr_1))  # Check if the expressions are different
    result = s.check()
    print(f"expr0 {expr_0}: expr_1 {expr_1}: result{result}")
    s.pop()  # Restore the previous context
    # If the expressions are different, the result will be sat
    return result == unsat




def create_petri_net_m0():
    petri_net = PetriNet("P01")
    places = {"P01": 0, "P02": 0, "P03": 0, "P04": 0, "P05": 0}
    for place, marking in places.items():
        petri_net.add_place(place, marking)
    transitions = {
        "t1": "gt1: True",
        "t2": "gt2: [i < l1]",
        "t3": "gt3: [i >= l1]",
        "t4": "gt4: [i < x]",
        "t5": "gt5: [i >= x]",
        "t6": "gt6: [y >= z]",
        "t7": "gt7: [y < z]",
        "t8": "gt8: True"
    }
    for transition, condition in transitions.items():
        petri_net.add_transition(transition, condition)
    formulas = {
        "F1": "x==h1,i==0,j==0,a==0,b==0,l1==0,l2==0,y==0,z==0,c==0",
        "F2": "b==a, a==a+h2, i==i+1",
        "F3": "c==b-l2",
        "F4": "y==l1+b, z==l1+5",
        "F5": "y==a+l2, z==l1+5",
        "F6": "c==l1-5",
        "F7": "c==l2+1",
        "F8": "out==c+y+z"
    }
    for formula, content in formulas.items():
        petri_net.add_formula(formula, content)
    input_arcs = [
        ("P01", "t1"),
        ("P02", "t2"),
        ("P02", "t3"),
        ("P03", "t4"),
        ("P03", "t5"),
        ("P04", "t6"),
        ("P04", "t7"),
        ("P05", "t8")
    ]
    for source, target in input_arcs:
        petri_net.add_input_arc(source, target)
    arcs = [
        ("t1", "F1"),
        ("t2", "F2"),
        ("t3", "F3"),
        ("t4", "F4"),
        ("t5", "F5"),
        ("t6", "F6"),
        ("t7", "F7"),
        ("t8", "F8")
    ]
    for source, target in arcs:
        petri_net.add_arcs(source, target)
    output_arcs = [
        ("F1", "P02"),
        ("F2", "P02"),
        ("F3", "P03"),
        ("F4", "P04"),
        ("F5", "P04"),
        ("F6", "P05"),
        ("F7", "P05"),
        ("F8", "P01")
    ]
    for source, target in output_arcs:
        petri_net.add_output_arc(source, target)
    return petri_net

def create_petri_net_m1():
    petri_net = PetriNet("P11")
    places = {"P11": 0, "P12": 0, "P13": 0, "P14": 0, "P15": 0}
    for place, marking in places.items():
        petri_net.add_place(place, marking)
    transitions = {
        "t1": "gt1: True",
        "t2": "gt2: [i < l1]",
        "t3": "gt3: [i >= l1]",
        "t4": "gt4: [i < x]",
        "t5": "gt5: [i >= x]",
        "t6": "gt6: [y >= z]",
        "t7": "gt7: [y < z]",
        "t8": "gt8: True"
    }
    for transition, condition in transitions.items():
        petri_net.add_transition(transition, condition)
    formulas = {
        "F1": "x==h1,i==0,j==0,a==0,b==0,l1==0,l2==0,y==0,z==0,c==0",
        "F2": "b==a , a==a+h2, i==i+1",
        "F3": "b==b-l2",
        "F4": "y==l1+b, z==l1+5",
        "F5": "y==a+l2, z==l1+5",
        "F6": "c==l1-5",
        "F7": "c==l2+1",
        "F8": "out==c+y+z"
    }
    for formula, content in formulas.items():
        petri_net.add_formula(formula, content)
    input_arcs = [
        ("P11", "t1"),
        ("P12", "t2"),
        ("P12", "t3"),
        ("P13", "t4"),
        ("P13", "t5"),
        ("P14", "t6"),
        ("P14", "t7"),
        ("P15", "t8")
    ]
    for source, target in input_arcs:
        petri_net.add_input_arc(source, target)
    arcs = [
        ("t1", "F1"),
        ("t2", "F2"),
        ("t3", "F3"),
        ("t4", "F4"),
        ("t5", "F5"),
        ("t6", "F6"),
        ("t7", "F7"),
        ("t8", "F8")
    ]
    for source, target in arcs:
        petri_net.add_arcs(source, target)
    output_arcs = [
        ("F1", "P12"),
        ("F2", "P12"),
        ("F3", "P13"),
        ("F4", "P14"),
        ("F5", "P14"),
        ("F6", "P15"),
        ("F7", "P15"),
        ("F8", "P11")
    ]
    for source, target in output_arcs:
        petri_net.add_output_arc(source, target)
    return petri_net
def main():
    # Create and process Petri net M0
    petri_net_m0 = create_petri_net_m0()
    print("Petrinet model for M0:")
    petri_net_m0.bfs("P01")
    print("\nPath Cover for M0:")
    petri_net_m0.print_path_cover()

    # Create and process Petri net M1
    petri_net_m1 = create_petri_net_m1()

    print("Petrinet Model for M1:")
    petri_net_m1.bfs("P11")
    print("\nPath Cover for M1:")
    petri_net_m1.print_path_cover()
    # Check for path equivalence
    print("\nChecking Path Equivalence:")
    if check_path_equivalence(petri_net_m0, petri_net_m1):
        print("All paths in petri_net_0 have corresponding paths in petri_net_1")

    else:
        print("Some paths in petri_net_0 do not have corresponding paths in petri_net_1")



if __name__ == "__main__":
    main()
