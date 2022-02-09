from typing import Dict, Any

import requests

from http_client import HTTPClient


class ArtifactoryHTTPClient():
    """
        Artifactory Client to wrap up calls to interesting API endpoints
        https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API
    """
    STORAGE_URL = "api/storage/"
    STATUS_PASSED = "PASSED"
    STATUS_FAILED = "FAILED"
    STATUS_ARTIFACT_CERTIFIED = "certified"
    STATUS_ARTIFACT_UNVERIFIED = "unverified"

    def __init__(self, client: HTTPClient, repo: str, dai_version: str):
        self.client = client
        self.repo = repo
        self.dai_version = dai_version

    @property
    def storage_path(self) -> str:
        """
        :return: server path to repo root
        """
        return f"{self.STORAGE_URL}/{self.repo}/{self.dai_version}"

    def get_items(self) -> requests.Response:
        """
        :return: Response containing all artifacts in teh given path
        """
        return self.client.get(f"{self.storage_path}?list&deep=1")

    def get_item_properties(self, item) -> requests.Response:
        """
        :param item: artifact name
        :return: Response containing all artifcat properties
        """
        return self.client.get(f"{self.storage_path}/{item}?properties")

    def get_artifacts_statuses(self, mlops_versions: list) -> list:
        """
        :param mlops_versions: list of mlops versions
        :return: table data containing statuses of artifacts against mlops versions
        """
        mlops_version_statuses: Dict[Any, str] = dict.fromkeys(mlops_versions, self.STATUS_PASSED)
        table_header = [f"DAI {self.dai_version} Artifact", *mlops_versions]
        data = [table_header]

        res = self.get_items()
        if res.status_code == 200:
            items = res.json()
            if 'files' in items:
                for item in items['files']:
                    res = self.get_item_properties(item['uri'])
                    row = []
                    for version in mlops_versions:
                        if res.status_code == 200 and version in res.json()['properties']:
                            status = res.json()['properties'][version][0]
                            row.append(status)
                            if status != self.STATUS_ARTIFACT_CERTIFIED:
                                mlops_version_statuses[version] = self.STATUS_FAILED
                        else:
                            row.append(self.STATUS_ARTIFACT_UNVERIFIED)
                            mlops_version_statuses[version] = self.STATUS_FAILED

                    data.append([item['uri'], *row])
                data.append(["", *mlops_version_statuses.values()])
        return data
