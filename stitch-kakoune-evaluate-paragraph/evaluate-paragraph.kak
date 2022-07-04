provide-module evaluate-paragraph %{

define-command evaluate-paragraph -override %{ evaluate-commands -draft %{
    execute-keys '<a-a>p:<c-r>.<ret>'
}}
map global user e ': evaluate-paragraph<ret>' -docstring 'Evaluate paragraph'

}
