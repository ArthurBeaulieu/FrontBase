#! /bin/bash
vers="0.1.0"

# Script welcome message and explanation

echo
echo -e "  ## ---------------------------------- ##"
echo -e "  ##        FrontBase installer         ##"
echo -e "  ##          2021 -- GPL-3.0           ##"
echo -e "  ##              v$vers                ##"
echo -e "  ## ---------------------------------- ##"
echo
echo -e This installer will update the configuration files to match your newly created project.
echo -e It will also create for you the es6 JavaScript class and the scss file.
echo -e First, we need several information about it :
echo

# Ask user mandatory information

read -p 'What is your GitHub username ? ' username
read -p 'What is the name of this project ? ' component
read -p 'How would you describe it ? ' description
read -p 'What is its version number ? ' version
read -p 'Which distribution license do you want to use ? ' license

# Creating .scss and .js files (source and test)

basedir=$(dirname "$0")

echo
echo -e "Handling js and scss files in src/js, test file and src/scss subdirectories"
echo -e " -> Creating required subdirectories"
mkdir -p src/js
mkdir -p src/scss
echo -e " -> Creating source files"
touch "$basedir"/src/scss/"$component".scss
{
	echo "* { box-sizing: border-box }"
} >> "$basedir"/src/scss/"$component".scss
touch "$basedir"/src/js/"$component".js
{
	echo "import '../scss/$component.scss"
	echo ""
	echo "class $component {"
	echo "  constructor() {}"
	echo "}"
	echo ""
	echo "export default $component"
} >> "$basedir"/src/js/"$component".js
touch "$basedir"/test/"$component".spec.js
{
	echo "import '../src/js/$component.js';"
	echo ""
	echo "describe('$component test', () => {"
	echo "  it('Unit test', done => {"
	echo "    done();"
	echo "  });"
	echo "});"
} >> "$basedir"/test/"$component".spec.js
echo -e "Source files successfully created"

# Replacing strings in files to properly prepare the folder

echo
echo -e "Fill configuration files with the information you provided"
echo -e " -> Replacing in demo/example.html"
# TODO
echo -e " -> Replacing in doc/jsDoc.json"
# TODO
echo -e " -> Replacing in webpack/plugins.js"
# TODO
echo -e " -> Replacing in webpack/webpack.common.js"
# TODO
echo -e " -> Replacing in package.json"
# TODO
echo -e "Configuration files are up and ready"

# Clear README.md and prepare it with user information

echo
echo -e "Editing README.md to match project information"
# TODO
echo -e "README.md file now reflect the new project"

# Using npm install if any, display error otherwise

echo
# TODO
echo -e "Running npm install to install component dependencies"
# TODO

# Clearing both .bat and .sh files

echo
echo -e "This script will now self-destruct to let you a properly use this dev environment"
echo -e "You can now start to develop. See package.json scripts commands for usage"
