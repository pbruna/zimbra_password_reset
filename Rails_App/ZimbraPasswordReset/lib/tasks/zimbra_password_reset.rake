# encoding: utf-8
namespace :zimbrapasswordreset do

  desc "Create Admin User. You must use an existing email."
  task :create_admin => :environment do
    if Users.any?
      puts "Ya existe un usuario"
    else
      print "Ingrese su Email del Administrador: "
      email = STDIN.gets.chomp
      print "\n"
      user = User.new(:email => email)
      if user.save
        puts "Usuario creado"
      else
        puts "No se pudo crear el usuario: #{account.errors.full_messages.join(", ")}"
      end
    end
  end

end
