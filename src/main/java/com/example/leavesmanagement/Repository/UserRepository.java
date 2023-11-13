package com.example.leavesmanagement.Repository;

import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.User;
import lombok.Cleanup;
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
                    .email(rs.getString("email"))
                    .password(rs.getString("password"))
                    .department(rs.getString("department"))
                    .role(rs.getString("role"))
                    .name(rs.getString("name"))
                    .sign(rs.getString("sign"))
                    .rest_leaves(rs.getInt("rest_leaves"))
                    .admin_role(rs.getInt("admin_role"))
                    .enter_date(rs.getDate("enter_date"))
                    .regist_date(rs.getDate("regist_date"))
                    .up_date(rs.getDate("up_date"))
                    .isdelete(rs.getInt("isdelete"))
                    .build();

        return returnValue;
    }

}
