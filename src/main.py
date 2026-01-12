import json

def load_report(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def print_summary(report):
    print(f"Overall Score: {report.get('overall_score', 'N/A')}")
    print(f"FPS Estimate: {report.get('fps_estimate', 'N/A')}")
    print("Bottlenecks:")
    for b in report.get("bottlenecks", []):
        print(f"- {b}")

if __name__ == "__main__":
    report = load_report("example_report.json")
    print_summary(report)
