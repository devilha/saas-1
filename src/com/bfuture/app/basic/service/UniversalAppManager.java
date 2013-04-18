package com.bfuture.app.basic.service;

/**
 * Business Facade interface. 
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 *
 * Modifications and comments by <a href="mailto:bwnoll@gmail.com">Bryan Noll</a>
 * This thing used to be named simply 'GenericManager' in versions of AppFuse prior to 2.0.
 * It was renamed in an attempt to distinguish and describe it as something
 * different than GenericManager.  GenericManager is intended for subclassing, and was
 * named Generic because 1) it has very general functionality and 2) is
 * 'generic' in the Java 5 sense of the word... aka... it uses Generics.
 *
 * Implementations of this class are not intended for subclassing. You most
 * likely would want to subclass GenericManager.  The only real difference is that
 * instances of java.lang.Class are passed into the methods in this class, and
 * they are part of the constructor in the GenericManager, hence you'll have to do
 * some casting if you use this one.
 *
 * @see com.einvite.service.GenericManager
 */
public interface UniversalAppManager extends BaseManager {
  
    
}
