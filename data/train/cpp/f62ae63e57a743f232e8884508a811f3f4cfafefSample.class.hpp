/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Sample.class.hpp                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jspezia <jspezia@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/01/07 18:58:10 by jspezia           #+#    #+#             */
/*   Updated: 2015/01/07 19:06:00 by jspezia          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef SAMPLE_CLASS_H
# define SAMPLE_CLASS_H

class Sample
{
	public:

		Sample(void);
		~Sample(void);

		void	bar(char const c) const;
		void	bar(int const n) const;
		void	bar(float const z) const;
		void	bar(Sample const  & i) const;

};

#endif /* !SAMPLE_CLASS_H */
