:silent %s#<+INCLUDE_GUARD+>#\=toupper(expand('%:r:gs?\\?/?:gs?/?_?')) . '_H'#ge
/*
 * <%= expand('%:gs?\\?/?') %>
 *
 *   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
 */

#ifndef <+INCLUDE_GUARD+>
# define <+INCLUDE_GUARD+>



# ifdef __cplusplus
extern "C" {
# endif /* __cplusplus */


<+CURSOR+>


# ifdef __cplusplus
}
# endif /* __cplusplus */

#endif /* <+INCLUDE_GUARD+> */
