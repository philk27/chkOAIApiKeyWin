# A PowerShell script to check an OpenAI API key and the available models

# Define a parameter for the OpenAI API key
Param (
    [Parameter(Mandatory=$true)]
    [string]$Key
)

# Import the Invoke-RestMethod cmdlet
Import-Module Microsoft.PowerShell.Utility

# Define the OpenAI API endpoints for organizations, engines and completions
$OrgUri = "https://api.openai.com/v1/organizations"
$EngUri = "https://api.openai.com/v1/engines"
$ComUri = "https://api.openai.com/v1/engines/{0}/completions"

# Define the authorization header with the key
$Headers = @{
    "Authorization" = "sk-$Key"
}

# Define hard-coded models of interest for exception reporting
$HardCodedModels = @(
    "text-davinci-002",
    "code-davinci-002",
    "text-davinci-003",
    "gpt-3.5-turbo-0301",
    "gpt-3.5-turbo-16k",
    "gpt-3.5-turbo-0613",
    "gpt-3.5-turbo-16k-0613",
    "gpt-3.5-turbo",
    "gpt-4",
    "gpt-4-0314",
    "gpt-4-32k",
    "gpt-4-32k-0314"
)

# Check if oaimodellist.txt exists and is not empty
if (Test-Path -Path .\oaimodellist.txt) {
    # Read the required models from the file
    $RequiredModels = Get-Content -Path .\oaimodellist.txt | Where-Object {$_ -ne ""}
}
else {
    # Use the hard-coded models as required models
    $RequiredModels = $HardCodedModels
}

# Define a list of humorous prompts to test the models
$Prompts = @(
    "Write me two haiku about mice.",
    "Write me a limerick about cheese.",
    "Write me a 4 line rap about bananas.",
    "Write me a recipe for jellybean cake.",
    "Write me a love letter to a toaster.",
    "Write me a horoscope for Aquarius.",
    "Write me a riddle about snow.",
    "Write me a tongue twister with the word 'purple'.",
    "Write me a slogan for a new brand of chocolate toothpaste.",
    "Write me a summary of the character 'James Bolivar digriz."
)

# Shuffle the prompts randomly
$ShuffledPrompts = $Prompts | Get-Random -Count $Prompts.Count

# Try to make a GET request to the OpenAI API for organizations
try {
    # Invoke the REST method and store the response
    $OrgResponse = Invoke-RestMethod -Headers $Headers -Uri $OrgUri -Method Get

    # Check if the status code is 200 (OK)
    if ($OrgResponse.StatusCode -eq 200) {
        # Print the organization ID and name
        Write-Host "The key is valid."
        Write-Host "Organization ID: $($OrgResponse.data.id)"
        Write-Host "Organization Name: $($OrgResponse.data.name)"
    }
}
catch {
    # Handle any errors that might occur
    Write-Host "The key is invalid or there was an error."
    Write-Host $_.Exception.Message

    # Print the exception report
    Write-Host "Exception Report:"
    Write-Host $_.Exception | Format-List -Force
}

# Try to make a GET request to the OpenAI API for engines
try {
    # Invoke the REST method and store the response
    $EngResponse = Invoke-RestMethod -Headers $Headers -Uri $EngUri -Method Get

    # Check if the status code is 200 (OK)
    if ($EngResponse.StatusCode -eq 200) {
        # Print the available engines and their status
        Write-Host "The available engines are:"
        foreach ($Engine in $EngResponse.data) {
            Write-Host "$($Engine.id): $($Engine.ready)"
        }

        # Get the list of available engine IDs
        $AvailableModels = $EngResponse.data.id

        # Find any missing models from the required models list
        $MissingModels = $RequiredModels | Where-Object {$AvailableModels -notcontains $_}

        # Print any missing models or a success message
        if ($MissingModels) {
            Write-Host "`nMissing models:"
            foreach ($Model in $MissingModels) {
                Write-Host "- $Model"
            }
        }
        else {
            Write-Host "`nAccess to all required models."
        }

        # Ask the user if they want to test some models with prompts
        $TestModels = Read-Host -Prompt "Do you want to test gpt-3 and gpt-4 models with prompts? (y/n)"

        # If the user answers yes, proceed with testing
        if ($TestModels -eq "y") {
            # Define a list of models to test
            $ModelsToTest = @(
                "gpt-3.5-turbo",
                "gpt-3.5-turbo-16k",
                "gpt-4-32k",
                "gpt-4"
            )

            # Loop through the models to test
            for ($i = 0; $i -lt $ModelsToTest.Count; $i++) {
                # Get the current model and prompt
                $Model = $ModelsToTest[$i]
                $Prompt = $ShuffledPrompts[$i]

                # Check if the model is available
                if ($AvailableModels -contains $Model) {
                    # Print the model and prompt
                    Write-Host "`nTesting model: $Model"
                    Write-Host "Prompt: $Prompt"

                    # Try to make a POST request to the OpenAI API for completions
                    try {
                        # Define the completion parameters
                        $Parameters = @{
                            "prompt" = $Prompt
                            "max_tokens" = 10
                            "temperature" = 0.5
                            "stop" = "\n"
                        }

                        # Invoke the REST method and store the response
                        $ComResponse = Invoke-RestMethod -Headers $Headers -Uri ($ComUri -f $Model) -Method Post -Body ($Parameters | ConvertTo-Json)

                        # Check if the status code is 200 (OK)
                        if ($ComResponse.StatusCode -eq 200) {
                            # Print the completion result
                            Write-Host "Result: $($ComResponse.choices[0].text)"
                        }
                    }
                    catch {
                        # Handle any errors that might occur
                        Write-Host "There was an error getting the completion."
                        Write-Host $_.Exception.Message

                        # Print the exception report
                        Write-Host "Exception Report:"
                        Write-Host $_.Exception | Format-List -Force
                    }
                }
                else {
                    # Print a message that the model is not available
                    Write-Host "`nModel not available: $Model"
                }
            }
        }
    }
}
catch {
    # Handle any errors that might occur
    Write-Host "There was an error getting the engines."
    Write-Host $_.Exception.Message

    # Print the exception report
    Write-Host "Exception Report:"
    Write-Host $_.Exception | Format-List -Force
}

}
