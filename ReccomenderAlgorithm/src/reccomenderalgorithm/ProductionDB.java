/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author grzala
 */
public class ProductionDB implements Database {
    
    String url;
    String user;
    String password;
    
    public HashMap<Integer, String> interest_groups = new HashMap<>();
    public HashMap<Integer, Interest> interests = new HashMap<>();
    
    
    //statements
    Connection con = null;
    final String getUsersSTMT = "SELECT * FROM unimatch.users;";
    final String getUserByIDSTMT = "SELECT * FROM unimatch.users WHERE id = ?";
    final String getUserInterestsSTMT = "SELECT * FROM unimatch.user_interests WHERE user_id = ? ;";
    final String getInterestGroupsSTMT = "SELECT * FROM unimatch.interest_groups";
    final String getInterestsSTMT = "SELECT * unimatch.FROM interests";

    
    public ProductionDB(String HOSTNAME, String user, String password) {
        this.url = "jdbc:mysql://" + HOSTNAME;
        this.user = user;
        this.password = password;
        connect();
        
        populateTables();
    }
    
    public void connect() {
        try {
            if (con != null && !con.isClosed()) return;
            con = (Connection) DriverManager.getConnection(url, user, password);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    private void populateTables() {
        
        try {
            PreparedStatement stmt = con.prepareStatement(getInterestGroupsSTMT);
            ResultSet rs; 
            
            //interest groups
            rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                interest_groups.put(id, name);
            }
            
            //interests 
            stmt = con.prepareStatement(getInterestsSTMT);
            rs = stmt.executeQuery();

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
            PreparedStatement stmt = con.prepareStatement(getUsersSTMT);
            ResultSet rs = stmt.executeQuery();
            
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
    
    public void close() {
        try {
            if (con != null) {
                con.close();
                con = null;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
}
