/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;


/**
 *
 * @author grzala
 */
public class DevelopmentDB implements Database{
        
    String filePath;
    
    //interests and groups are fixed, restart algorithm server if changes are made
    public HashMap<Integer, String> interest_groups = new HashMap<>();
    public HashMap<Integer, Interest> interests = new HashMap<>();
    
    //statements
    Connection con = null;
    final String getUsersSTMT = "SELECT * FROM users;";
    final String getUserByIDSTMT = "SELECT * FROM users WHERE id = ?";
    final String getUserInterestsSTMT = "SELECT * FROM user_interests WHERE user_id = ? ;";
    final String getInterestGroupsSTMT = "SELECT * FROM interest_groups";
    final String getInterestsSTMT = "SELECT * FROM interests";

    
    public DevelopmentDB(String filePath) {
        this.filePath = filePath;
        connect();
        
        populateTables();
    }
    
    private void connect() {
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:" + filePath);
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            System.exit(0);
        }
        //System.out.println("Opened database successfully");
    }
    
    //gets user By ID alongside with his interests
    public User getUserByID(int id) { 
        User usr = null;
        try {
            PreparedStatement getUser = con.prepareStatement(getUserByIDSTMT);
            getUser.setInt(1, id);
            ResultSet rs = getUser.executeQuery();
            
            String name = rs.getString("name");
            String surname = rs.getString("surname");
            usr = new User(id, name, surname);
            usr.interests = getUserInterests(usr.id);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usr;
    }
    
    public ArrayList<User> getUsers() {
        ArrayList<User> result = new ArrayList<User>();
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(getUsersSTMT);
            
            while (rs.next()) {
                int id = rs.getInt("id");
                result.add(getUserByID(id));
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public ArrayList<Interest> getUserInterests(int id) {
        ArrayList<Interest> result = new ArrayList<Interest>();
        try {
            PreparedStatement getUserInterest = con.prepareStatement(getUserInterestsSTMT);
            getUserInterest.setInt(1, id);
            ResultSet rs = getUserInterest.executeQuery();
            
            while (rs.next()) {
                int interest_id = rs.getInt("interest_id");
                result.add(findInterestByID(interest_id));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public ArrayList<Interest> getInterests() {
        return new ArrayList<Interest>(interests.values());
    }
    
    public Interest findInterestByID(int id) {
        return interests.get(id);
    }
    
    private void populateTables() {
        try {
            Statement stmt = con.createStatement();
            ResultSet rs; 
            //interest groups
            rs = stmt.executeQuery(getInterestGroupsSTMT);

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                interest_groups.put(id, name);
            }
            
            //interests 
            rs = stmt.executeQuery(getInterestsSTMT);

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                Interest interest = new Interest(id, name, interest_groups.get(rs.getInt("interest_group_id")));
                interests.put(id, interest);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void close() {
        try {
            con.close();
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
        
}
