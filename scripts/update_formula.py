from pathlib import Path
import argparse
import re
import urllib
import urllib.request
import hashlib
import os


def main():
    
    parser = argparse.ArgumentParser(description="Update homebrew formula to new version")
    parser.add_argument("--formula", type=str, default=None, help="The formula to update")
    parser.add_argument("--src-repository", type=str, default=None, help="The source repository")
    parser.add_argument("--tag-name", type=str, default=None, help="The tag name. Must be semver based")

    args = parser.parse_args()

    tag_name = args.tag_name
    if tag_name is None:
        tag_name = os.environ["INPUT_TAG_NAME"]

    semver_regex = r"^v((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))(?:(-(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"

    tag_name_r = re.match(semver_regex,tag_name)

    formula_name = args.formula
    if formula_name is None:
        formula_name = os.environ["INPUT_FORMULA"]

    with open(f"Formula/{formula_name}.rb", "r") as f:
        formula_rb = f.read()
        
    repo = args.src_repository
    if repo is None:
        repo = os.environ["INPUT_SOURCE_REPOSITORY"]

    tarball_url = f"https://github.com/{repo}/archive/{tag_name}.tar.gz"
    
    print("Begin download")

    req = urllib.request.Request(tarball_url, headers={"Accept": "application/octet-stream"})
    response = urllib.request.urlopen(req)
    file_data = response.read()

    print("End download")

    tarball_sha256 = hashlib.sha256(file_data).hexdigest()
    

    print(tarball_sha256)
    
    homebrew_ver =  tag_name_r.group(1) + tag_name_r.group(2)
    
    formula_rb2 = re.sub(r"(\surl\s+)([^\s]+)",f"\\g<1>\"{tarball_url}\"", formula_rb)
    formula_rb3 = re.sub(r'(\ssha256\s+)("[A-Za-z0-9]+")',f"\\g<1>\"{tarball_sha256}\"", formula_rb2)
    print(formula_rb3)

    with open(f"Formula/{formula_name}.rb", "w") as f:
        f.write(formula_rb3)



if __name__ == "__main__":
    main()