#   Copyright 2017 Javier Sevilla
#    
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


require "digest/md5"


def addUser
    puts "-------------------------------------------------------------"
    puts "----- ADD USER"
    puts "-------------------------------------------------------------"
    
    print "USERNAME: "
    userName = STDIN.gets.chomp
    print "PASSWORD: "
    userPass = STDIN.gets.chomp
    print "ADMIN? (true/false): "
    userIsAdmin = STDIN.gets.chomp == "true" ? true : false
    
    puts "\n----- CONFIRM ACTION"
    puts "USERNAME: " + userName + "\nPASSWORD: " + userPass + "\nADMIN?: " + userIsAdmin.to_s
    puts "\nContinue? (yes/no)"
    createUser = STDIN.gets.chomp
    
    if createUser == "yes"
        #HA1 digest password (better than storing a plain pass)
        ha1 = Digest::MD5.hexdigest([userName,Rails.application.config.realm,userPass].join(":"))
        
        newUser = User.new(name: userName, password: ha1, admin: userIsAdmin)
        
        if newUser.save
            puts "\nThe user has been saved."
        else
            puts "\nERROR: An error ocurred while saving the user."
            if newUser.errors.any?
                newUser.errors.full_messages.each do |msg|
                    puts "\t" + msg
                end
            end
        end
    else
        puts "\nThe user has not been saved."
    end
end


def deleteUser
    puts "-------------------------------------------------------------"
    puts "----- DELETE USER"
    puts "-------------------------------------------------------------"
    
    print "User ID: "
    userID = STDIN.gets.chomp
    
    user = nil
    
    begin
        user = User.find(userID)
    rescue ActiveRecord::RecordNotFound
        puts "There is no user with ID " + userID
    end
    
    if user
        puts "--- CONFIRM ACTION"
        puts "ID: " + user.id.to_s + "\nUSERNAME: " + user.name + "\nADMIN?: " + user.admin.to_s
        puts "\nContinue? (yes/no)"
        destroyUser = STDIN.gets.chomp
        
        if destroyUser == "yes"
            user.destroy
            
            puts "\nThe user has been deleted."
        else
            puts "\nThe user has not been deleted."
        end
    end
end


def listUsers
    puts "-------------------------------------------------------------"
    puts "----- LIST OF ALL USERS"
    puts "-------------------------------------------------------------"

    puts "\nID\t|\tUSERNAME\t|\tADMIN"
    User.all.each do |user|
        puts user.id.to_s + "\t|\t" + user.name + "\t|\t" + user.admin.to_s
    end
end


def printError
    puts "ERROR. Use: users_management.rb [OPTION]\n\nOptions:\n\tadd\tAdd user\n\tdelete\tDelete user\n\tlist\tList all users"
end



if ARGV.length != 1
    printError
    exit 1
else
    if ARGV[0] == "add"
        addUser
    elsif ARGV[0] == "delete"
        deleteUser
    elsif ARGV[0] == "list"
        listUsers
    else
        printError
        exit 1
    end
end

