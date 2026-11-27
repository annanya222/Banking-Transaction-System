package com.banking.system.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "customers")
@Getter
@Setter
@NoArgsConstructor
public class Customer {

@Id 
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "customer_id")
private Long customerId;

}