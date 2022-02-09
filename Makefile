# ENV Variables
ARTIFACTORY_URL?=http://localhost:8081/artifactory
ARTIFACTORY_REPOSITORY_PATH=example-repo-local/dai
ARTIFACTORY_USER?=admin
ARTIFACTORY_PASSWORD?=password
MLOPS_VERSIONS?=mlops-0.53 mlops-0.54
DAI_VERSION?=10.0.1
REPO?=example-repo-local/dai
REPORTS_DIR?=certification-report

venv:
	python3 -m venv venv
	./venv/bin/python3 -m pip install --upgrade pip

.PHONY: setup
setup: venv
	./venv/bin/python3 -m pip install -r requirements.txt

create-reports-dir:
	mkdir -p $(REPORTS_DIR)

clean:
	rm -rf $(REPORTS_DIR)

.PHONY: run
run: create-reports-dir
	./venv/bin/python3 reports/report.py \
		--mlops_versions $(MLOPS_VERSIONS)  \
		--dai_version=$(DAI_VERSION) \
		--repo=$(REPO) \
		--artifactory_url=$(ARTIFACTORY_URL) \
		--artifactory_user=$(ARTIFACTORY_USER) \
		--artifactory_password=$(ARTIFACTORY_PASSWORD) \
		--reports_dir=$(REPORTS_DIR)

