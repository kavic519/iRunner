package com.zjgsu.irunner.entity;

import javax.persistence.*;

@Entity
@Table(name = "coordinates")
public class Coordinate {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private Double latitude;        // 纬度
    @Column(nullable = false)
    private Double longitude;       // 经度
    @Column(name = "sequence_order")
    private Integer order;          // 坐标顺序
    // 添加基本类型ID字段用于MyBatis
    @Column(name = "run_session_id")
    private Long runSessionId;      // 关联跑步记录
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "run_session_id", insertable = false, updatable = false)
    private RunSession runSession;

    // 构造函数
    public Coordinate() {}

    public Coordinate(Double latitude, Double longitude, Integer order) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.order = order;
    }

    public Coordinate(Double latitude, Double longitude, Integer order, Long runSessionId) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.order = order;
        this.runSessionId = runSessionId;
    }

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Integer getOrder() { return order; }
    public void setOrder(Integer order) { this.order = order; }

    public Long getRunSessionId() { return runSessionId; }
    public void setRunSessionId(Long runSessionId) {
        this.runSessionId = runSessionId;
    }

    public RunSession getRunSession() { return runSession; }
    public void setRunSession(RunSession runSession) {
        this.runSession = runSession;
        if (runSession != null) {
            this.runSessionId = runSession.getId();
        }
    }
}