/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author u02mfp14
 */
public interface Database {
    
    public User getUserByID(int id);
    public Society getSocietyByID(int id);
    public ArrayList<User> getUsers();
    public ArrayList<Society> getSocieties();
    
    public ArrayList<Interest> getInterests();
    
    public void saveMatches(int id, HashMap<Integer, Float> matches, String type);
    
    public void connect();
    public void close();
    public boolean isClosed();
    
}
