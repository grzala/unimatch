/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

/**
 *
 * @author u01ydd14
 */
public class FakeDatabase {
    
    public Interest[] interests = {
        new Interest(0, "Football", "Sport"),
        new Interest(1, "Rugby", "Sport"),
        new Interest(2, "Surfing", "Sport"),
        new Interest(3, "Squash", "Sport"),
    };
    
    public User[] users = {
        new User(1, "Michael", "Smith"),
        new User(2, "Jack", "Smith"),
        new User(3, "John", "Smith"),
        new User(4, "Robert", "Smith"),
    };
            
    public FakeDatabase() {
        users[0].addInterest(interests[0]);
        users[0].addInterest(interests[1]);
        users[0].addInterest(interests[3]);
        
        
        users[1].addInterest(interests[1]);
        users[1].addInterest(interests[2]);
        
        
        users[2].addInterest(interests[2]);
        
        users[3].addInterest(interests[0]);
        users[3].addInterest(interests[3]);
    }
    
}
