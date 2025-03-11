
ctags doesn't create tags for directories whose name starts with `.`, to make it create tags for them, use the command  
`ctags --recurse=yes --exclude-exception=*/.lib/* .* *`
