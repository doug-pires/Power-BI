let
    Source = (col as text , to_language as text ) as text => let

        url = "https://api.cognitive.microsofttranslator.com/translate",
        api_key = "YOUR_KEY" ,
        region = "YOUR_REGION",
        content_type = "application/json",


        to = if to_language = null then "en" else to_language,

        // Build Headers
        Headers=[ #"Ocp-Apim-Subscription-Key"= api_key, #"Ocp-Apim-Subscription-Region"=region,  #"Content-type"=content_type ],

        // Build the Body
        // From your Default Language
        query = [#"api-version" ="3.0", from="en", to= to],

        // Call for a Simple text
        text_raw = "Hi, I am Douglas Pires and I am implementing an Azure AI Service",

        postData = Text.ToBinary( "[{   ""text"": """& col &"""   }]" ),

        // Call the Web.Contents
        web_call = Web.Contents (url, [ Headers=Headers,Query = query, Content = postData  ]  ),


        json_value = Json.Document (web_call),

        get_first_value = json_value{0},
        get_translations = get_first_value[translations],
        translation = get_translations{0},
        get_attribute_text = translation[#"text"]

    in
    get_attribute_text
in
    Source