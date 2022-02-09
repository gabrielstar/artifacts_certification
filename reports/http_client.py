from abc import ABC
from typing import Union
import requests
from requests.auth import AuthBase
from abc import abstractmethod


class AbstractHTTPClient(ABC):
    @abstractmethod
    def get(self):
        pass

    @abstractmethod
    def delete(self):
        pass

    @abstractmethod
    def post(self):
        pass

    @abstractmethod
    def put(self):
        pass


class HTTPClient(AbstractHTTPClient):
    def __init__(self, auth: Union[tuple, AuthBase], url: str):
        self.url = url
        self.auth = auth

    @property
    def session(self) -> requests.Session:
        session = requests.Session()
        session.auth = self.auth

        return session

    def delete(self, url: str) -> requests.Response:
        return self.session.delete(f'{self.url}/{url}')

    def get(self, url: str) -> requests.Response:
        return self.session.get(f'{self.url}/{url}')

    def post(self, url: str, payload: dict, default_headers: dict=None) -> requests.Response:
        if default_headers is None:
            default_headers = {'content-type': 'application/json'}
        self.session.headers.update(default_headers)
        return self.session.post(f'{self.url}/{url}', json=payload)

    def put(self):
        raise NotImplementedError
