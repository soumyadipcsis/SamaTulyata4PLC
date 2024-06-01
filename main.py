import sys
from petri_net import PetriNet, check_path_equivalence


def create_petri_net_from_file(file_path):
    petri_net = PetriNet()
    with open(file_path, 'r') as file:
        lines = file.readlines()
        print(lines,end=" ")

    section = None
    for line in lines:
        line = line.strip()
        if line.startswith("#"):
            section = line[1:].strip()
        else:
            if section == "PLACES":
                place, marking = line.split()
                petri_net.add_place(place, int(marking))
            elif section == "TRANSITIONS":
                transition, formula = line.split(":")
                petri_net.add_transition(transition.strip(), formula.strip())
            elif section == "FORMULAS":
                formula, content = line.split(":")
                petri_net.add_formula(formula.strip(), content.strip())
            elif section == "INPUT_ARCS":
                source, target = line.split("->")
                petri_net.add_input_arc(source.strip(), target.strip())
            elif section == "ARCS":
                source, target = line.split("->")
                petri_net.add_arcs(source.strip(), target.strip())
            elif section == "OUTPUT_ARCS":
                source, target = line.split("->")
                petri_net.add_output_arc(source.strip(), target.strip())
            elif section == "INPUT_PLACES":
                inputplace = line.strip()
                petri_net.input_places.append(inputplace)

    return petri_net


def main():
    if len(sys.argv) != 3:
        print("Usage: python main.py <file1> <file2>")
        sys.exit(1)

    file_path_1 = sys.argv[1]
    file_path_2 = sys.argv[2]

    petri_net_m0 = create_petri_net_from_file(file_path_1)
    petri_net_m1 = create_petri_net_from_file(file_path_2)

    start_place_1 = petri_net_m0.input_places[0]
    start_place_2 = petri_net_m1.input_places[0]

    petri_net_m0.reset_state = start_place_1
    petri_net_m1.reset_state = start_place_2

    print("\nPaths for M0:")
    petri_net_m0.print_path_cover()
    print("\nPaths for M1:")
    petri_net_m1.print_path_cover()

    print("\nChecking Path Equivalence:")
    if check_path_equivalence(petri_net_m0, petri_net_m1):
        print("Two Models are Equivalent")
    else:
        print("Two Models are Not Equivalent")


if __name__ == "__main__":
    main()
