/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Sample.class.hpp                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jspezia <jspezia@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/01/07 18:58:10 by jspezia           #+#    #+#             */
/*   Updated: 2015/01/07 20:46:49 by jspezia          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef SAMPLE_CLASS_H
# define SAMPLE_CLASS_H

#include <iostream>

class Sample
{
	public:

		Sample(void);
		Sample(int const n);
		Sample(Sample const &src);
		~Sample(void);

		Sample		&operator=(Sample const &rhs);

		int		getFoo(void) const;

	private:

		int		_foo;
};

std::ostream		&operator<<(std::ostream &o, Sample const &i);

#endif /* !SAMPLE_CLASS_H */
