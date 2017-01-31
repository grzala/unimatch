/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;

/**
 *
 * @author u02mfp14
 */
public interface Database {
    
    public User getUserByID(int id);
    public ArrayList<User> getUsers();
    
    public ArrayList<Interest> getInterests();
    
}
