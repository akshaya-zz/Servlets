package com.akshaya.welcome;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@ServerEndpoint("/score")
public class ScoreSocket {
static Set<Session> sessions = new CopyOnWriteArraySet<>();
 ScheduledExecutorService scheduledExecutorService;
 static int score = 0;
    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);

        System.out.println("WebSocket Opened: " + session.getId());
        // The 'session' parameter is required to use session.getId()
        if(scheduledExecutorService == null|| scheduledExecutorService.isShutdown()){
            scheduledExecutorService = Executors.newScheduledThreadPool(1);
        }
        scheduledExecutorService.scheduleAtFixedRate(()->{
            score += 6;
            for(Session s : sessions){
                try{
                    s.getBasicRemote().sendText("Score: " + score);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },0,1,TimeUnit.SECONDS);

    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("Received: " + message + " from " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        System.out.println("WebSocket Closed: " + session.getId());
        if(sessions.isEmpty()){
            scheduledExecutorService.shutdown();
            System.out.println("The scheduler is closed");
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Error on session " + session.getId() + ": " + throwable.getMessage());
    }
}