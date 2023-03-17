let
    Source =
        let
            UTC1 = try Number.From(#"UTC+1") otherwise 1,
            UTC2 = try Number.From(#"UTC+2") otherwise 2,
            UTC3 = try Number.From(#"UTC+3") otherwise 3,
            ///////////////////////////////////////////////////////////////////////////////
            backbone = {
                [
                    LastRefresh = Text.Start(
                        Text.From(DateTimeZone.FixedUtcNow() + #duration(0, UTC2, 0, 0), "en-us"), 15
                    ),
                    UTC = "UTC+" & #"UTC+2",
                    UTCNumber = UTC2
                ],
                [
                    LastRefresh = Text.Start(
                        Text.From(DateTimeZone.FixedUtcNow() + #duration(0, UTC1, 0, 0), "en-us"), 15
                    ),
                    UTC = "UTC+" & #"UTC+1",
                    UTCNumber = UTC1
                ],
                [
                    LastRefresh = Text.Start(Text.From(DateTimeZone.UtcNow() + #duration(0, UTC3, 0, 0), "en-us"), 15),
                    UTC = "UTC+" & #"UTC+3",
                    UTCNumber = UTC3
                ]
            }
        in
            backbone,
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(
        #"Converted to Table", "Column1", {"LastRefresh", "UTC", "UTCNumber"}, {"LastRefresh", "UTC", "UTCNumber"}
    ),
    #"Extract Time" = Table.AddColumn(
        #"Expanded Column1", "Time", each Text.AfterDelimiter([LastRefresh], " "), type text
    ),
    ExtractAM_PM = Table.AddColumn(
        #"Extract Time",
        "Period",
        each
            let
                UtcAdjusted = DateTimeZone.FixedUtcNow() + #duration(0, [UTCNumber], 0, 0),
                ExtractAM_PM = Text.BetweenDelimiters(Text.From(UtcAdjusted, "en-US"), " ", " ", 1, 0)
            in
                ExtractAM_PM
    ),
    #"Remove Time" = Table.TransformColumns(
        ExtractAM_PM, {{"LastRefresh", each Text.BeforeDelimiter(_, " "), type text}}
    ),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(
        #"Remove Time", {{"Time", each Text.BeforeDelimiter(_, ":", 1), type text}}
    ),
    #"Added Index" = Table.AddIndexColumn(#"Extracted Text Before Delimiter", "Index", 1, 1, Int64.Type),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Added Index", {{"LastRefresh", type date}}, "en-US"),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Changed Type with Locale", {"LastRefresh", "UTC", "Time", "Period", "Index"}
    ),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Removed Other Columns", {{"UTC", type text}, {"Period", type text}}
    )
in
    #"Changed Type"
