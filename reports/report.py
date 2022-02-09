from http_client import HTTPClient
from artifactory_client import ArtifactoryHTTPClient
import pandas as pd
from pretty_html_table import build_table
import argparse


def run(mlops_versions, dai_version, repo, artifactory_url, artifactory_user, artifactory_password, reports_dir):
    client = HTTPClient(auth=(artifactory_user, artifactory_password), url=artifactory_url)
    artifactory_client = ArtifactoryHTTPClient(client, repo, dai_version)

    _df = artifactory_client.get_artifacts_statuses(mlops_versions)
    df = pd.DataFrame(_df)
    with open(f"{reports_dir}/report.html", "w") as f:
        f.write(build_table(df, 'blue_light', ))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Artifacts certification statuses from Artifactory')
    parser.add_argument("--mlops_versions", nargs="+", metavar="LIST_OF_MLOPS_VERSIONS",
                        default=['mlops-0.53', 'mlops-0.54', 'mlops-0.59'])
    parser.add_argument("--dai_version", metavar="DRIVERLESS_AI_VERSION",
                        default="10.0.1")
    parser.add_argument("--repo", metavar="ARTIFACTORY_REPOSITORY_PATH",
                        default="example-repo-local/dai")
    parser.add_argument("--artifactory_url", metavar="ARTIFACTORY_URL",
                        default="http://localhost:8081/artifactory")
    parser.add_argument("--artifactory_user", metavar="ARTIFACTORY_USER",
                        default="admin")
    parser.add_argument("--artifactory_password", metavar="ARTIFACTORY_PASSWORD",
                        default="password")
    parser.add_argument("--reports_dir", metavar="REPORTS_DIR",
                        default="../certification-report")
    args = vars(parser.parse_args())

    run(**args)
