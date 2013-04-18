package com.bfuture.app.saas.clientapp.controller;

import java.util.LinkedHashSet;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.saas.model.SysScmuser;


/**
 * 统计在线用户
 *
 * @author 丁元
 */
public class UserCounterListener implements ServletContextListener, HttpSessionAttributeListener {

    private transient ServletContext servletContext;
    private int counter;
    private Set<SysScmuser> SmUsers;

    /**
     * Initialize the context
     * @param sce the event
     */
    public synchronized void contextInitialized(ServletContextEvent sce) {
        servletContext = sce.getServletContext();
        servletContext.setAttribute((Constants.COUNT_KEY), Integer.toString(counter));
    }

    /**
     * Set the servletContext, SmUsers and counter to null
     * @param event The servletContextEvent
     */
    public synchronized void contextDestroyed(ServletContextEvent event) {
        servletContext = null;
        SmUsers = null;
        counter = 0;
    }

    synchronized void incrementSmUserCounter() {
        counter = Integer.parseInt((String) servletContext.getAttribute(Constants.COUNT_KEY));
        counter++;
        servletContext.setAttribute(Constants.COUNT_KEY, Integer.toString(counter));
    }

    synchronized void decrementSmUserCounter() {
        int counter = Integer.parseInt((String) servletContext.getAttribute(Constants.COUNT_KEY));
        counter--;

        if (counter < 0) {
            counter = 0;
        }

        servletContext.setAttribute(Constants.COUNT_KEY, Integer.toString(counter));
    }

    @SuppressWarnings("unchecked")
    synchronized void addSmUser(SysScmuser smUser) {
        SmUsers = (Set) servletContext.getAttribute(Constants.SmUserS_KEY);

        if (SmUsers == null) {
            SmUsers = new LinkedHashSet<SysScmuser>();
        }

        if (!SmUsers.contains(smUser)) {
            SmUsers.add(smUser);
            servletContext.setAttribute(Constants.SmUserS_KEY, SmUsers);
            incrementSmUserCounter();
        }
    }

    synchronized void removeSmUser(SysScmuser smUser) {
        SmUsers = (Set) servletContext.getAttribute(Constants.SmUserS_KEY);

        if (SmUsers != null) {
            SmUsers.remove(smUser);
        }

        servletContext.setAttribute(Constants.SmUserS_KEY, SmUsers);
        decrementSmUserCounter();
    }

    /**
     * This method is designed to catch when SmUser's login and record their name
     * @see javax.servlet.http.HttpSessionAttributeListener#attributeAdded(javax.servlet.http.HttpSessionBindingEvent)
     * @param event the event to process
     */
    public void attributeAdded(HttpSessionBindingEvent event) {
        if (event.getName().equals( Constants.LOGIN_USER ) ) {
            
        	SysScmuser smUser = (SysScmuser) event.getValue();
            addSmUser(smUser);
            
        }
    }

    /**
     * When SmUser's logout, remove their name from the hashMap
     * @see javax.servlet.http.HttpSessionAttributeListener#attributeRemoved(javax.servlet.http.HttpSessionBindingEvent)
     * @param event the session binding event
     */
    public void attributeRemoved(HttpSessionBindingEvent event) {
    	if (event.getName().equals( Constants.LOGIN_USER ) ) {
    		SysScmuser smUser = (SysScmuser) event.getValue();
    		removeSmUser(smUser);
           
        }
    }

    /**
     * Needed for Acegi Security 1.0, as it adds an anonymous SmUser to the session and
     * then replaces it after authentication. http://forum.springframework.org/showthread.php?p=63593
     * @see javax.servlet.http.HttpSessionAttributeListener#attributeReplaced(javax.servlet.http.HttpSessionBindingEvent)
     * @param event the session binding event
     */
    public void attributeReplaced(HttpSessionBindingEvent event) {
    	if (event.getName().equals( Constants.LOGIN_USER ) ) {
            
        	SysScmuser smUser = (SysScmuser) event.getValue();
            addSmUser(smUser);
            
        }
    }
}
