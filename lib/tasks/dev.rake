namespace :dev do

  DEFAULT_PASSWORD = 123456 
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Set up the development environment"
  task setup: :environment do
    
    if(Rails.env.development?)

      show_spinner("Erasing database...", "Task finished! | 1/8" ) do

        %x(rails db:drop)

      end



      show_spinner("Creating database...", "Task finished! | 2/8" ) do

        %x(rails db:create)

      end

      show_spinner("Migrating database...", "Task finished! | 3/8" ) do

        %x(rails db:migrate)

      end

      show_spinner("Adding default admin...", "Task finished! | 4/8" ) do

        %x(rails dev:add_default_admin)

      end

      show_spinner("Adding default user...", "Task finished! | 5/8" ) do

        %x(rails dev:add_default_user)

      end

      show_spinner("Adding extra admin...", "Task finished! | 6/8" ) do

        %x(rails dev:add_extra_admins)

      end

      show_spinner("Registering default subjects...", "Task finished! | 7/8" ) do

        %x(rails dev:add_subjects)

      end

      show_spinner("Registering default questions and answers...", "Task finished! | 8/8" ) do

        %x(rails dev:add_questions_and_answers)

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

  desc "Register default subjects"
  task add_subjects: :environment do

    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      
      Subject.create!(description: line.strip)

    end
  
  end

  desc "Register default questions and answers"
  task add_questions_and_answers: :environment do

    Subject.all.each do |subject|

      rand(2..10).times do |i|

        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        correct_answer(answers_array)

        Question.create!(params[:question])

      end

    end
  
  end

  private

    def create_question_params(subject = Subject.all.sample)

      { question: { 

        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []

      }}

    end

    def create_answer_params(correct = false)

      { 

        description: Faker::Lorem.sentence, 
        correct: correct

      }     

    end

    def add_answers(answers_array = [])

      rand(2..5).times do |j|

        answers_array.push(create_answer_params(true))

      end

    end

    def correct_answer(answers_array = [])
    
      selected_index = rand(answers_array.size)
      answers_array[selected_index] = create_answer_params(true)
      
    end

    def show_spinner(msg_start, msg_end)

      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots) 
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")

    end

end
