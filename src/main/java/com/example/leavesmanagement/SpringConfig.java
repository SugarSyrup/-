package com.example.leavesmanagement;

import com.example.leavesmanagement.Repository.LeavesRepository;
import com.example.leavesmanagement.Repository.SwiftCodeRepository;
import com.example.leavesmanagement.Repository.UserRepository;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
public class SpringConfig {
    private final DataSource dataSource;

    public SpringConfig(DataSource datasource) {
        this.dataSource = datasource;
    }

    public SwiftCodeRepository swiftCodeRepository() {
        return new SwiftCodeRepository(dataSource);
    }

    public LeavesRepository leavesRepository() { return new LeavesRepository(dataSource); }

    public UserRepository userRepository() { return new UserRepository(dataSource); }

}
