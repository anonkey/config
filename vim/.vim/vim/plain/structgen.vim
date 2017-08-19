" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    structgen.vim                                      :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: tseguier <marvin@42.fr>                    +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2014/12/25 13:47:57 by tseguier          #+#    #+#              "
"    Updated: 2014/12/25 16:22:23 by tseguier         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

function! Struct(name)
	let name=a:name


	execute("tabe t_".name.".h")
	execute("normal itypedef struct\t\t\ts_".name)
	execute("normal o{\r}\t\t\t\t\tt_s".name.";")
	execute("normal o")
	execute("normal otypedef t_s".name."\t\t*t_".name.";")
	execute("normal o")
"	execute("normal :w<CR>")

	execute("tabe ft_".name."_priv.h")
	execute("normal i#include \"t_".name.".h\"")
"	execute("normal :w<CR>")

	execute("tabe ft_".name.".h")
	execute("normal i#include \"t_".name.".h\"")
	execute("normal o")
	"enum
	execute("normal ot_".name."\tft_".name."new();")
	execute("normal ovoid\t\tft_".name."del(t_".name." *".name."_p);")
	execute("normal oint\t\t\tft_".name."init(t_".name." ".name.");")
	execute("normal ovoid\t\tft_".name."clr(t_".name." ".name.");")
	execute("normal o")
"	execute("normal :w<CR>")
"
	execute("tabe ft_".name.".c")
	execute("normal ot_".name."\tft_".name."new()\r{\r}\r")
	execute("normal ovoid\t\tft_".name."del(t_".name." *".name."_p)\r{\r}\r")
	execute("normal oint\t\t\tft_".name."init(t_".name." ".name.")\r{\r}\r")
	execute("normal ovoid\t\tft_".name."clr(t_".name." ".name.")\r{\r}\r")
	execute("normal o")
"	execute("normal :w<CR>")
endfunction