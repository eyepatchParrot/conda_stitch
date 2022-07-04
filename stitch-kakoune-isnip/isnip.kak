# isnip snippets use the colon separated text immediately to the left
# of your cursor to generate a snippet.  Currently, this only supports
# a WORD, so no spaces are allowed. A future breaking change would be
# to require an enclosing block.
# 
# This can be used independently as:
# require-module isnip            # snippets only
# require-module isnip-usermode   # snippets with file specific usermode, but not the insert entry 
# require-module isnip-map-insert # snippets with user mode and <a-f> for entry
#
# Example use: While in insert mode, and typing something like:
# node:history
# Hit <a-f> while still in insert-mode, and select foreach-mutable. This expands to:
# for (auto& node : history) {
#    
# }
# With the cursor in the middle of the body

provide-module isnip %{

# isnip-detail works by splitting on : delimited arguments, pasting those
# over templates named ISNIP_ARG, then resumes editing from ISNIP_BODY

define-command isnip-detail -hidden -params 1 -override %{ evaluate-commands -save-regs xyz %{
    set-register y %arg{1}
    execute-keys '<a-a><a-w>S:<ret>"xy<a-a><a-w>d"yp"zZsISNIP_ARG<ret>d"xP"zzsISNIP_BODY<ret>c'
}}
define-command isnip-for-each-mutable -override %{ isnip-detail %{
for (auto& ISNIP_ARG : ISNIP_ARG) {
    ISNIP_BODY
}
}}

} # isnip

provide-module isnip-usermode %{

require-module isnip

define-command -hidden isnip-hook-cpp %{
    try { remove-hooks window isnip-hook-group-cpp }
    hook -group isnip-hook-group-cpp global WinSetOption filetype=cpp %{
        map window isnip f ': isnip-for-each-mutable<ret>' -docstring 'foreach-mutable' 
    }
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window isnip-hook-group-cpp
    }
}

declare-user-mode isnip
} # isnip-usermode

provide-module isnip-map-insert %{

require-module isnip-usermode
map global insert <a-f> %{<esc>h: enter-user-mode isnip<ret>} -docstring 'isnip mode: foreach-mutable'

} # isnip-map-insert

