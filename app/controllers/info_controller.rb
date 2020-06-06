class InfoController < ApplicationController
  def about
    @president = User.find_by id: 1
    # @p_admins = User.where(:admin_category => "physics").where.not( :id => "1").order("created_at ASC")
    # @c_admins = User.where(:admin_category => "chemistry").order("created_at ASC")
    # @b_admins = User.where(:admin_category => "biology").order("created_at ASC")
    # @m_admins = User.where(:admin_category => "maths").order("created_at ASC")
    # @n_admins = User.where(:admin_category => "nepali").order("created_at ASC")
    # @e_admins = User.where(:admin_category => "english").order("created_at ASC")

    set_meta_tags title: 'Online Learning Platform', site: 'About Mattrab',
                  og: { title: 'Online Learning Platform' },
                  twitter: { title: 'Online Learning Platform' }
  end

  def faqs
    set_meta_tags title: 'Bridging the gap among education quality in Nepal.', site: 'About Mattrab',
                  og: { title: 'Bridging the gap among education quality in Nepal.' },
                  twitter: { title: 'Bridging the gap among education quality in Nepal.' }
  end

  def affiliate_program
    set_meta_tags title: 'Advertise and Grow you Business', site: 'Mattrab', description: 'Join Mattrab affiliate program and healthily advertise/promote your business. Company or organization benefitting the students are always helped by Mattrab.',
                  og: { title: 'Advertise and Grow you Business', description: 'Join Mattrab affiliate program and healthily advertise/promote your business. Company or organization benefitting the students are always helped by Mattrab.' },
                  twitter: { title: 'Advertise and Grow you Business', description: 'Join Mattrab affiliate program and healthily advertise/promote your business. Company or organization benefitting the students are always helped by Mattrab.' }
  end

  def terms
    set_meta_tags title: 'Terms of Service', site: 'Mattrab', description: 'These terms and conditions (Terms of Service) govern your use of this website askmattrab.com. Please read the terms to fruitfully use the website and grow yourself.',
                  og: { title: 'Terms of Service', description: 'These terms and conditions (Terms of Service) govern your use of this website askmattrab.com. Please read the terms to fruitfully use the website and grow yourself.' },
                  twitter: { title: 'Terms of Service', description: 'These terms and conditions (Terms of Service) govern your use of this website askmattrab.com. Please read the terms to fruitfully use the website and grow yourself.' }
  end

  def privacy
    set_meta_tags title: 'Privacy Policy', site: 'Mattrab', description: 'We know that you care about how your information is collected, used and shared, and we take your privacy seriously. Please read this Privacy Policy carefully to learn more about our privacy practices.',
                  og: { title: 'Privacy Policy', description: 'We know that you care about how your information is collected, used and shared, and we take your privacy seriously. Please read this Privacy Policy carefully to learn more about our privacy practices.' },
                  twitter: { title: 'Privacy Policy', description: 'We know that you care about how your information is collected, used and shared, and we take your privacy seriously. Please read this Privacy Policy carefully to learn more about our privacy practices.' }
  end

  def creator_appeal
    set_meta_tags title: 'Be a Mattrab Creator', site: 'Mattrab', description: 'Join the proud Mattrab Creator Community today and make the difference. If you are confident of delivering the good quality academic resoucres, kindly follow the steps.',
                  og: { title: 'Be a Mattrab Creator', description: 'Join the proud Mattrab Creator Community today and make the difference. If you are confident of delivering the good quality academic resoucres, kindly follow the steps.' },
                  twitter: { title: 'Be a Mattrab Creator', description: 'Join the proud Mattrab Creator Community today and make the difference. If you are confident of delivering the good quality academic resoucres, kindly follow the steps.' }
  end
end
