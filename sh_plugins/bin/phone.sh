# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    phone.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tseguier <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2014/07/04 16:26:03 by tseguier          #+#    #+#              #
#    Updated: 2014/07/04 16:26:39 by tseguier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ldapsearch uid=$1 | grep  mobile-phone