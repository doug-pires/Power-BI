let
    Last_Refresh = Table.RenameColumns(
        Table.FromList({Text.Start(Text.From(DateTimeZone.UtcNow() - #duration(0, 3, 0, 0), "pt-br"), 16)}),
        {{"Column1", "Last Refresh Date Time"}}
    ),
    #"Changed Type" = Table.TransformColumnTypes(Last_Refresh, {{"Last Refresh Date Time", type text}})
in
    #"Changed Type"
