namespace :dev do

  DEFAULT_PASSWORD = 123456 

  desc "Set up the development environment"
  task setup: :environment do
    
    if(Rails.env.development?)

      show_spinner("Erasing database...", "Task finished! | 1/6" ) do

        %x(rails db:drop)

      end

      show_spinner("Creating database...", "Task finished! | 2/6" ) do

        %x(rails db:create)

      end

      show_spinner("Migrating database...", "Task finished! | 3/6" ) do

        %x(rails db:migrate)

      end

      show_spinner("Adding default admin...", "Task finished! | 4/6" ) do

        %x(rails dev:add_default_admin)

      end

      show_spinner("Adding default user...", "Task finished! | 5/6" ) do

        %x(rails dev:add_default_user)

      end

      show_spinner("Adding extra admin...", "Task finished! | 6/6" ) do

        %x(rails dev:add_extra_admins)

      end

    else

      puts "You are not in development environment"

    end

  end

  desc "Adds a default admin"
  task add_default_admin: :environment do
    
    Admin.create!(

      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD

    )
  
  end

  desc "Adds a default user"
  task add_default_user: :environment do
    
    User.create!(

      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD

    )
  
  end

  desc "Adds extra admins"
  task add_extra_admins: :environment do

    10.times do |i|
    
      Admin.create!(

        email: Faker::Internet.email ,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD

      )
    
    end
  
  end

  private

    def show_spinner(msg_start, msg_end)

      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots) 
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")

    end

end
