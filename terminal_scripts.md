each script that is callable via terminal/ command line should be set up like this


if certain libraries are not installed write instructions of how to install them to stdout: 

for the new python this is for example 
    print("Use a virtual environment instead:\n")
    print("  python3 -m venv venv")
    print("  source venv/bin/activate")
    print("  pip install git+https://github.com/cvg/LightGlue")


after this parse the arguments. also write to the stdout a minimal overview of possible arguments and if they were set or not and what the default is 

then the script can do the processing

while the script is running it can write to the stdout human readable output

if the script needs to communicate to a computer it can write an encoded string in any format. encoded strings have to be marked with a start and end tag , a encoded string would look like this , but all on one line
{s_uuid}_start_{format}
{formated_data}
{s_uuid}_end_{format}
the s_uuid is taken from a .env ,and the programm that calls the script will also know that same uuid, this way it can parse all important data for the program. the most common and preferred format is JSON.

