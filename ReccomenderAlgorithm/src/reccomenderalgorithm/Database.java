/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;
import com.sun.corba.se.impl.util.Version;
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
public class Database {
    
    public HashMap<Integer, String> interest_groups = new HashMap<>();
    public HashMap<Integer, Interest> interests = new HashMap<>();
    public HashMap<Integer, User> users = new HashMap<>();
    
    Connection con = null;

    String url = "jdbc:mysql://unimatch.ddns.net";
    String user = "alg";
    String password = "alg";
    
    public Database() {
        connect();
        
        populateTables();
        
        close();
        
    }
    
    private void populateTables() {
        ResultSet rs = null;
        PreparedStatement pst = null;
        try {
            //interest groups
            pst = con.prepareStatement("SELECT * FROM unimatch.interest_groups");
            rs = pst.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                interest_groups.put(id, name);
            }
            
            //interests
            pst = con.prepareStatement("SELECT * FROM unimatch.interests");
            PreparedStatement get_group_query = con.prepareStatement("SELECT name FROM unimatch.interest_groups WHERE id = ?");
            ResultSet group_result = null;
            rs = pst.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                int group_id = rs.getInt("interest_group_id");
                String name = rs.getString("name");
                get_group_query.setInt(1, group_id);
                group_result = get_group_query.executeQuery(); group_result.first();
                interests.put(id, new Interest(id, name, group_result.getString("name")));
            }
            
            //close statements
            if(group_result != null) {
                group_result.close();
                get_group_query.close();
            }
            
            
            //users
            pst = con.prepareStatement("SELECT * FROM unimatch.users");
            rs = pst.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String surname = rs.getString("surname");
                users.put(id, new User(id, name, surname));
            }
            
            //add user interests
            PreparedStatement get_user_interests = con.prepareStatement("SELECT interest_id FROM unimatch.user_interests WHERE user_id = ?");
            ResultSet user_interests = null;
            
            for (int key : users.keySet()) {
                get_user_interests.setInt(1, key);
                user_interests = get_user_interests.executeQuery();
                while (user_interests.next()) {
                    int interest_id = user_interests.getInt("interest_id");
                    Interest in = interests.get(interest_id);
                    users.get(key).interests.add(in);
                }
            }
            
            //close statements
            if(user_interests != null) {
                user_interests.close();
                get_user_interests.close();
            }
            
        } catch (SQLException ex) {
            reportException(ex);
        } finally {
            try {
                if(rs != null) 
                    rs.close();
                if(pst != null)
                    pst.close();
            } catch (SQLException ex) {
                reportException(ex);
            }
        }
    }
    
    private void connect() {
        try {
            con = (Connection) DriverManager.getConnection(url, user, password);
        } catch (SQLException ex) {
            reportException(ex);
        }
    }
    
    public void close() {
        try {
            if (con != null) {
                con.close();
            }
        } catch (SQLException ex) {
            reportException(ex);
        }
    }
    
    private void reportException(SQLException ex) {
        Logger lgr = Logger.getLogger(Version.class.getName());
        lgr.log(Level.SEVERE, ex.getMessage(), ex);
    }
    
}
