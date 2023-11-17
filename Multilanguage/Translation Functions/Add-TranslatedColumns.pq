let
    Source = (orginal_table_in_english as table , language as text, latest_step as table ) => let
        Source = let

    only_text_cols_to_translate = Table.SelectRows ( Table.Schema( orginal_table_in_english ), each [Kind] = "text" )[Name],
    language_to = language,
    new_col_name = " Translated "& Text.Upper ( language_to ),
    results = List.Accumulate(only_text_cols_to_translate, latest_step, (state, current) => Table.AddColumn( state,current & new_col_name, each  #"Translate-Text" ( Record.Field ( _ ,current ),language_to ), type text ) )
    in
        results
    in
        Source
in
    Source