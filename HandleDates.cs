// Convert all the Date Column that is in General and Long Date to Short Date
foreach(var column in Model.Tables.SelectMany(t => t.Columns)) 
{
    if (column.FormatString == "General Date")column.FormatString = "Short Date";

    if (column.FormatString == "Long Date")column.FormatString = "Short Date";  
}