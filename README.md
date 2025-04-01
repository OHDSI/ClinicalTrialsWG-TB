# Clinical trial data conventions for the OMOP Common Data Model

This repository aims to apply OMOP Clinical Trials conventions for converting SDTM Pulmonary Tuberculosis data into the OMOP Common Data Model (CDM).

For more information about the Clinical trials conventions, please visit our [wiki](https://github.com/OHDSI/ClinicalTrialsWGETL/wiki) or download [pdf](docs/omop_clinical_trials_data_conventions_v1.0_July_2020.pdf) version.



## Clinical Trials Working Group

About the group - see [here](https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:clinicalstudy).


## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.


## dbt

This section describes setup of a dbt project for converting the TB-1015 SDTM dataset into the OMOP Common Data Model.

### Prerequisites
- See the top of [this page](https://docs.getdbt.com/docs/core/pip-install) for OS & Python requirements.  (Do NOT install dbt yet - see below for project installation and setup.)
- It is recommended to use [VS Code](https://code.visualstudio.com/) as your IDE for developing this project.  Install the `dbt Power User` extension in VS Code to enjoy a plethora of useful features that make dbt development easier
- Python **3.12.0** is the suggested version of Python for this project
- A local copy of the TB-1015 dataset in csv format

### Repo Setup
 1. Clone this repository to your machine
 2. `cd` into the repo directory and set up a virtual environment:
 ```bash
 python3 -m venv dbt-env
 ```
 - If you are using VS Code, create a .env file in  the root of your repo workspace (`touch .env`) and add a PYTHONPATH entry for your virtual env (for example, if you cloned your repo in your computer's home directory, the entry will read as: `PYTHONPATH="~/ClinicalTrialsWG-TB/dbt-env/bin/python"`)
 - Now, in VS Code, once you set this virtualenv as your preferred interpreter for the project, the vscode config in the repo will automatically source this env each time you open a new terminal in the project.  Otherwise, each time you open a new terminal to use dbt for this project, run:
```bash
source dbt-env/bin/activate         # activate the environment for Mac and Linux OR
dbt-env\Scripts\activate            # activate the environment for Windows
```
3. Set up your [profiles.yml file](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml).  You can either:
   - Create a file in the `~/.dbt/` directory named `profiles.yml` (if you've already got this directory and file, you can skip this step and add profile block(s) for this project to that file)
   - Create a `profiles.yml` file in the root of the `ClinicalTrialsWG-TB` repo folder
   - Create the file wherever you wish, following the guidance [here](https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles#advanced-customizing-a-profile-directory)

### DuckDB Setup
 1. In your virtual environment install requirements for duckdb (see [here for contents](./requirements/duckdb.in))
```bash
pip3 install -r requirements/duckdb.txt
pre-commit install
```

 2. Add the following block to your `profiles.yml` file:
```yaml
ctwg_tb:
  outputs:
    dev:
      type: duckdb
      path: ctwg_tb.duckdb
      schema: dbt_ctwg_tb_dev
  target: dev
```

 3. Ensure your profile is setup correctly using dbt debug:
```bash
dbt debug
```

 4. Load dbt dependencies:
```bash
dbt deps
```

 5. Load your SDTM data into the database by running the following commands (modify the commands as needed to specify the path to the folder on your computer storing the SDTM csv files). The SDTM tables will be created in a schema named according to the target schema specified in your profiles.yml for the profile you are targeting, postfixed with "_sdtm".
```bash
file_dict=$(python3 scripts/python/get_csv_filepaths.py path/to/sdtm/csvs)
python3 scripts/python/clean_csvs.py $file_dict
dbt run-operation load_data_duckdb --args "{file_dict: $file_dict, vocab_tables: false}"
```

 6. If you have the OMOP Standardized Vocabularies csv files downloaded and available on your computer, load them into the database using the following commands.  The vocabulary tables will be created in the target schema specified in your profiles.yml for the profile you are targeting.  If you're unable to download the vocabulary files, see below for instructions on creating an empty set of vocabulary tables.  The data in the vocabulary tables is not used directly in the ETL.
```bash
file_dict=$(python3 scripts/python/get_csv_filepaths.py path/to/vocab/csvs)
dbt run-operation load_data_duckdb --args "{file_dict: $file_dict, vocab_tables: true}"
```

 7. Build the OMOP tables and run tests:
```bash
dbt build
# or `dbt run`, `dbt test`
```

#### Creating Empty Vocabulary Tables
If you do not have the OMOP vocabulary files available, you can simply create empty vocabulary tables as placeholders by running the following command.  This command will create the OMOP CDM vocabulary tables in the target schema specified in your profiles.yml for the profile you are targeting.  NOTE, with empty vocabulary tables the CDM your ETL produces will *not* be useful for analytics.
```bash
dbt run-operation create_vocab_tables
```