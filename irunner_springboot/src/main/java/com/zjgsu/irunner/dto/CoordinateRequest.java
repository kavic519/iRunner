package com.zjgsu.irunner.dto;

public class CoordinateRequest {

    private Double latitude;
    private Double longitude;
    private Integer order;

    // 构造函数
    public CoordinateRequest() {}

    public CoordinateRequest(Double latitude, Double longitude, Integer order) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.order = order;
    }

    // Getter 和 Setter 方法
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Integer getOrder() { return order; }
    public void setOrder(Integer order) { this.order = order; }
}