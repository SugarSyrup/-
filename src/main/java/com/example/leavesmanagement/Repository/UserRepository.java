package com.example.leavesmanagement.Repository;

import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.RepositoryMessage;
import com.example.leavesmanagement.entity.User;
import lombok.Cleanup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Repository
public class UserRepository {
    private final DataSource dataSource;
    @Autowired
    private PasswordEncoder passwordEncoder;
    public UserRepository(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public User findUser(int user_no) throws Exception {
        String sql = "select * from user where user_no = ?;";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, user_no);
        rs = pstmt.executeQuery();

        rs.next();
        User returnValue = User.builder()
                    .user_no(rs.getInt("user_no"))
                    .id(rs.getString("id"))
                    .password(rs.getString("password"))
                    .department(rs.getString("department"))
                    .role(rs.getString("role"))
                    .name(rs.getString("name"))
                    .sign(rs.getString("sign"))
                    .leavesDays(rs.getInt("leavesDays"))
                    .admin_role(rs.getString("admin_role"))
                    .enter_date(rs.getDate("enter_date"))
                    .regist_date(rs.getDate("regist_date"))
                    .up_date(rs.getDate("up_date"))
                    .isdelete(rs.getInt("isdelete"))
                    .build();

        return returnValue;
    }

    public RepositoryMessage<User> Login(String id, String password) throws Exception{
        String sql = "select * from user where id = ?";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        RepositoryMessage<User> returnValue = new RepositoryMessage<User>();
        if(rs.next()) {
            User user = User.builder()
                    .user_no(rs.getInt("user_no"))
                    .id(rs.getString("id"))
                    .password(rs.getString("password"))
                    .department(rs.getString("department"))
                    .role(rs.getString("role"))
                    .name(rs.getString("name"))
                    .sign(rs.getString("sign"))
                    .leavesDays(rs.getInt("leavesDays"))
                    .admin_role(rs.getString("admin_role"))
                    .enter_date(rs.getDate("enter_date"))
                    .regist_date(rs.getDate("regist_date"))
                    .up_date(rs.getDate("up_date"))
                    .isdelete(rs.getInt("isdelete"))
                    .build();

            if (passwordEncoder.matches(password, user.getPassword())) {
                returnValue.setSuccess(true);
                returnValue.setMessage("로그인 성공");
                returnValue.setObj(user);
            } else {
                returnValue.setSuccess(false);
                returnValue.setMessage("비밀번호가 일치하지 않습니다");
            }

        } else {
            returnValue.setSuccess(false);
            returnValue.setMessage("존재하지 않는 id 입니다");
        }

        return returnValue;
    }

    public void signup(User user) throws Exception {
        String sql = "INSERT INTO user (id, password, name, department, role, sign) VALUE (?, ?, ?, ?, ?, ?)";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user.getId());
        pstmt.setString(2, passwordEncoder.encode(user.getPassword()));
        pstmt.setString(3, user.getName());
        pstmt.setString(4, user.getDepartment());
        pstmt.setString(5, user.getRole());
        pstmt.setString(6, user.getSign());

        pstmt.executeQuery();
    }

}
