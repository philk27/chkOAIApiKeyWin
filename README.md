# CheckOpenAIKey.ps1

This is a PowerShell script that checks an OpenAI API key and the available models. It also allows the user to test some models with humorous prompts and see the completion results.

## Requirements

- PowerShell 7.3 or higher
- An OpenAI API key
- An optional text file named oaimodellist.txt with a list of required models

## Get an API key
Go to OpenAI's Platform website at https://platform.openai.com and sign in with an OpenAI account.
Click your profile icon at the top-right corner of the page and select "View API Keys."
Click "Create New Secret Key" to generate a new API key.
You will need a paid key to use most services so set up billing and billing constraints

GPT-4 waitlist: https://openai.com/waitlist/gpt-4-api
You cannot use gpt-4 models unless you have been granted access from the wait list
At the time of writing there is noway to see where you are in the wait list or accelerate access.  Be patient!

What is an API key? https://www.howtogeek.com/343877/what-is-an-api/


## Usage

To run this script, you need to save it in a file (e.g., CheckOpenAIKey.ps1) and then invoke it from a PowerShell console with the key as an argument. For example:

```powershell
.\CheckOpenAIKey.ps1 sk_1234567890abcdefg
```

The script will perform the following steps:

- Validate the key and print the organization ID and name
- Get the list of available engines and their status
- Compare the available engines with the required models (from oaimodellist.txt or hard-coded) and print any missing models
- Ask the user if they want to test some models with prompts
- If yes, loop through a list of models to test (gpt-3.5-turbo, gpt-3.5-turbo-16k, gpt-4-32k, gpt-4) and use a random prompt for each model
- Make a POST request to the OpenAI API for completions using the model and prompt, and print the result or an error message

## Example Output

Here is an example output of running the script:

```powershell
.\CheckOpenAIKey.ps1 sk_1234567890abcdefg

The key is valid.
Organization ID: org_1234567890abcdefg
Organization Name: My Organization
The available engines are:
ada: True
babbage: True
curie: True
curie-instruct-beta: True
davinci: True
davinci-codex: True
davinci-instruct-beta: True

Missing models:
- code-davinci-002
- text-davinci-003
- gpt-4
- gpt-4-0314
- gpt-4-32k
- gpt-4-32k-0314

Do you want to test some models with prompts? (y/n): y

Testing model: gpt-3.5-turbo
Prompt: Write me two haiku about mice.
Result: Mice are very small / They like to nibble on cheese / And run from the cat

Mice are furry friends / They squeak and scamper around / Sometimes they bring gifts

Testing model: gpt-3.5-turbo-16k
Prompt: Write me a limerick about cheese.
Result: There once was a man who loved cheese / He ate it for breakfast with ease / But one day he found / That he had gained a pound / And now he can't fit in his jeans

Testing model: gpt-4
Model not available: gpt-4
```

#Disclaimer
This script is provided "as is" without warranty of any kind, either express or implied, including but not limited to the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and performance of the script is with you. Should the script prove defective, you assume the cost of all necessary servicing, repair or correction.
