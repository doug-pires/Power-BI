


// Refresh Date
Text.Start ( Text.From (  DateTimeZone.UtcNow() - #duration ( 0,3,0,0) ,"pt-br"  ), 16 )

/*DAX 
Atualização = 
CONCATENATEX( 'Ult Atualização',"Últ. Atualização em "& LEFT ( 'Ult Atualização'[Ult Atualização],10 ) & " às " & RIGHT ('Ult Atualização'[Ult Atualização],5 )  )*/