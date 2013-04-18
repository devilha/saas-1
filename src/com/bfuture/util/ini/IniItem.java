/*
 * Java INI Package
 * Copyright (C) 2008 David Lewis
 * 
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public Licence as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public Licence for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

package com.bfuture.util.ini;

/**
 * <p>The IniItem class represents the simplest element of an INI file, an item,
 * which has only two important properties, a name and a value.</p>
 *
 * <p>Any primitive type can be saved as a value of this item, and any objects
 * saved as a value are converted to a String via the object's
 * <code>toString()</code>, however all values returned by an item are returned
 * as a </code>String</code>.</p>
 * 
 * @author David Lewis
 * @version 1.1.0
 * @since 0.1.10
 */
public class IniItem implements Commentable, Cloneable {
    
    /**
     * The name of this item
     */
    private String name;
    
    /**
     * The value of this item
     */
    private String value;
    
    /**
     * The comment that comes before the item
     */
    private String preComment;
    
    /**
     * The comment that comes after the item, but on the same line
     */
    private String endLineComment;
    
    /**
     * The comment that comes after the item.
     */
    private String postComment;
    
    /**
     * The IniValidator which validates the name of this <code>IniItem</code>
     */
    private IniValidator validator;
    
    /**
     * Predicate that is true if this <code>IniItem</code> is case sensitive, or
     * false if the <code>IniItem</code> is case insensitive. 
     */
    private boolean caseSensitive;

    /**
     * <p>Default constructor which creates a new instance of this 
     * <code>IniItem</code> and sets the <code>IniItem</code> to have a
     * default <code>IniValidator</code> and to be case insensitive.</p>
     * 
     * @param name The name of this <code>IniItem</code>.
     * @throws InvalidNameException if the name of the <code>IniItem</code>
     * given is not considered valid by this object's <code>IniValidator</code>.
     */
    public IniItem( String name ) {
        this( name, new IniValidator(), false );
    }

    /**
     * <p>Default constructor which creates a new instance of this 
     * <code>IniItem</code> and sets the <code>IniItem</code> to have a
     * default <code>IniValidator</code>.</p>
     * 
     * @param name The name of this <code>IniItem</code>.
     * @param caseSensitive Sets whether this <code>IniItem</code> is case 
     * sensitive.
     * @throws InvalidNameException if the name of the <code>IniItem</code>
     * given is not considered valid by this object's <code>IniValidator</code>.
     */
    public IniItem( String name, boolean caseSensitive ) {
        this( name, new IniValidator(), caseSensitive );
    }

    /**
     * <p>Default constructor which creates a new instance of this 
     * <code>IniItem</code> and sets the <code>IniItem</code> to be case 
     * insensitive.</p>
     * 
     * @param name The name of this <code>IniItem</code>.
     * @param validator The validator of this <code>IniItem</code>.
     * @throws InvalidNameException if the name of the <code>IniItem</code>
     * given is not considered valid by this object's <code>IniValidator</code>.
     */
    public IniItem( String name, IniValidator validator ) {
        this( name, validator, false );
    }
    
    /**
     * <p>Default constructor which creates a new instance of this 
     * <code>IniItem</code>.</p>
     * 
     * @param name The name of this <code>IniItem</code>.
     * @param validator The validator of this <code>IniItem</code>.
     * @param caseSensitive Sets whether this <code>IniItem</code> is case 
     * sensitive.
     * @throws InvalidNameException if the name of the <code>IniItem</code>
     * given is not considered valid by this object's <code>IniValidator</code>.
     */
    public IniItem( String name, IniValidator validator, boolean caseSensitive ) {
        
        this.validator = validator;
        
        if( !validator.isValidItemName(name) ) {
            throw new InvalidNameException( "The String \"" + name + 
                    "\" is not a valid name for a IniItem" );
        }
        
        this.caseSensitive = caseSensitive; 
        
        /* UNSURE IF THERE IS A NEED TO CONVERT THE ITEM NAME TO LOWER CASE...
        // set the name
        if( !isCaseSensitive() ) {
            name = name.toLowerCase();
        }
        */
        
        this.name = name;

        setValue( "" );
        setPreComment( "" );
        setEndLineComment( "" );
        setPostComment( "" );
    }
    
    /**
     * This method clears the value of this item.
     * 
     * @return Returns true is the item's value was cleared successfully, false
     * otherwise.
     */
    public boolean clear() {
        setValue( null );
        
        return true;
    }
    
    /**
     * <p>This predicate returns true if this <code>IniItem</code> is equal to
     * the given object. For <code>otherObject</code> to be equal to this one it
     * must:</p>
     * 
     * <ul>
     *   <li>be an instance of <code>IniItem</code>.</li>
     *   <li>have the same case-sensitivity as this <code>IniItem</code>.
     *   <li>have an equal <code>IniValidator</code> as this
     *       <code>IniItem</code>'s <code>IniValidator</code>.</li>
     *   <li>have an equal name as this <code>IniItem</code>.*</li>
     *   <li>have an equal value as this <code>IniItem</code>.*</li>
     *   <li>have an equal pre-comment as this <code>IniItem</code>.*</li>
     *   <li>have an equal post-comment as this <code>IniItem</code>.*</li>
     *   <li>have an equal end-line-comment as this <code>IniItem</code>.*</li>
     * </ul>
     * 
     * <p>* If the two <code>IniItem</code>s are 
     * <strong>case-sensitive</strong>, then these are compared using the
     * <code>equals(Object)</code> method. If the two <code>IniItem</code>s are 
     * <strong>case-insensitive</strong>, then these are compared using the
     * <code>String.equalsIgnoreCase(String)</code> method.</p>
     * 
     * @param otherObject The other Object to test for equality.
     * @return True if equal, false if not equal.
     * @since 0.1.15
     */
    @Override
    public boolean equals( Object otherObject ) {
        
        IniItem otherItem;
        
        /***********************************************************************
         * check to see if the other object is an instance of the same class
         **********************************************************************/
        if( !(otherObject instanceof IniItem) ) {
            return false;
        }
        else {
            otherItem = (IniItem) otherObject;
        }

        /***********************************************************************
         * check to see if the two IniItems have the same case sensitive setting
         **********************************************************************/
        if( this.isCaseSensitive() != otherItem.isCaseSensitive() ) {
            return false;
        }

        /***********************************************************************
         * check to see if the two IniItems have the same IniValidator
         **********************************************************************/
        if( !this.getValidator().equals(otherItem.getValidator()) ) {
            return false;
        }

        /***********************************************************************
         * check to see if the two IniItems have the same name
         **********************************************************************/
        if( !testStrings(this.getName(),otherItem.getName()) ) {
            return false;
        }
        
        /***********************************************************************
         * check that the two items have the same pre comments 
         **********************************************************************/
        String thisComment = this.getPreComment();
        String otherComment = otherItem.getPreComment();
        
        if( !testStrings(thisComment,otherComment) ) {
            return false;
        }
        
        /***********************************************************************
         * check that the two items have the same end-line comments 
         **********************************************************************/
        thisComment = this.getEndLineComment();
        otherComment = otherItem.getEndLineComment();

        if( !testStrings(thisComment,otherComment) ) {
            return false;
        }
        
        /***********************************************************************
         * check that the two items have the same post comments 
         **********************************************************************/
        thisComment = this.getPostComment();
        otherComment = otherItem.getPostComment();

        if( !testStrings(thisComment,otherComment) ) {
            return false;
        }

        /***********************************************************************
         * otherwise compare the values of the two items
         **********************************************************************/
        String thisValue = this.getValue();
        String otherValue = otherItem.getValue();
        
        if( thisValue == null ) {
            return otherItem.getValue() == null;
        }
        else {
            return testStrings(thisValue,otherValue);
        }
    }    
    
    public String getEndLineComment() {
        return endLineComment;
    }

    /**
     * Returns the name of this item, note that the item cannot change its name
     * and one would need to create a new item to do so.
     * 
     * @return the name of this item
     */
    public String getName() {
        return name;
    }
   
    public String getPostComment() {
        return postComment;
    }
    
    public String getPreComment() {
        return preComment;
    }
    
    /**
     * <p>Gets a reference to this object's <code>IniValidator</code>.</p>
     * 
     * @return The <code>IniValidator</code> used by this
     * <code>IniItem</code>.
     * @since 0.1.17
     */
    public IniValidator getValidator() {
        return validator;
    }

    /**
     * This returns the String which this items stores. If the item has no 
     * value, then null is returned.
     *  
     * @return <strong>String</strong>, the value of this item.
     */
    public String getValue() {
        return value;
    }
    
    public String getValue( String defaultValue ) {
    	if( value == null || "".equals( value ) )
    		return defaultValue;
        return value;
    }

    @Override
    public int hashCode() {
        
        int nameHashCode = getName().hashCode();
        int valueHashCode = getValue().hashCode();
        
        return (nameHashCode + valueHashCode) % Integer.MAX_VALUE; 
    }

    
    /**
     * Predicate that returns true if this item has a value, or false if it is empty
     * @return true or false
     */
    public boolean hasValue() {
        return !value.equals("");
    }

    /**
     * <p>Predicate that returns true if this <code>IniItem</code> is case
     * <strong>sensitive</strong>, or false if this <code>IniItem</code> is
     * case <strong>insensitive</strong>.</p>
     * 
     * @return boolean
     * @since 0.1.16
     */
    public boolean isCaseSensitive() {
        return caseSensitive;
    }

    public void removeEndLineComment() {
        setEndLineComment("");
    }

    public void removePostComment() {
        setPostComment("");
    }

    public void removePreComment() {
        setPreComment("");
    }
   
    public void setEndLineComment( String comment ) {
        
        if( comment == null ) {
            comment = "";
        }
        
        if( comment.contains("\n") ) {
            throw new IllegalArgumentException( "The string given contains a " +
                    "new line symbol. End line comments cannot contain new " +
                    "line symbol." );
        }
        
        endLineComment = comment;
    }

    public void setPostComment( String comment ) {
        
        if( comment == null ) {
            comment = "";
        }
        
        postComment = comment;
    }

    public void setPreComment( String comment ) {
        
        if( comment == null ) {
            comment = "";
        }
        
        preComment = comment;
    }

    /**
     * Set the value as a boolean value
     * 
     * @param value The value to set.
     */
    public void setValue( boolean value ) {
        setValue( String.valueOf(value) );
    }
    
    /**
     * Set the value as a character value
     * 
     * @param value The value to set.
     */
    public void setValue( char value ) {
        setValue( String.valueOf(value) );
    }
    
    /**
     * Set the value as a double value
     * 
     * @param value The value to set.
     */
    public void setValue( double value ) {
        this.value = Double.toString( value );
    }
    
    /**
     * Set the value as a float value
     * 
     * @param value the value to set
     */
    public void setValue( long value ) {
        this.value = Long.toString( value );
    }
    
    /**
     * This set the value to an Object when it has been converted to a String.
     * 
     * @param value the value to set
     */
    public void setValue( Object value ) {

        if( value == null ) {
            this.value = "";
        }
        else {
            setValue( value.toString() );
        }
    }
    
    /**
     * Set the value as a String value
     * 
     * @param value the value to set
     */
    public void setValue( String value ) {
        if( value == null ) {
            this.value = "";
        }
        else {
            this.value = value;
        }
    }
    
    /**
     * <p>Predicate that test's whether the two given strings are equal. This 
     * method is used rather than
     * <code><em>String</em>.<strong>equals</strong>(<em>Object</em>)</code>
     * method as this method takes into account if this <code>IniItem</code> is
     * case sensitive or not.</p>
     * <p>This method, like the equals method, is commutative, and therefore
     * it does not matter which string is the first and which string is the
     * second as the same result will be returned.</p>
     * 
     * @param string1 The first string to test
     * @param string2 The second string to test.
     * @return True if the two strings are equal, false if they are not
     */
    private boolean testStrings( String string1, String string2 ) {
        
        // if this IniItem is case sensitive, then compare the two string with
        // case sensitivity
        if( caseSensitive ) {
            return string1.equals(string2);
        }
        else {
            // IniItem is case insensitive, therefore, compare strings whilst
            // ignoring case sensitivity.
            return string1.equalsIgnoreCase(string2);
        }
    }
    
    @Override
    public String toString() {
        return "org.dtools.ini.IniItem \"" + getName() +
               "\": (Value: \"" + getValue() + "\")";
    }
    
    @Override
    public Object clone() {
        
        IniItem clone = new IniItem( new String(name), (IniValidator) validator.clone(), caseSensitive );
        clone.setValue( new String(value) );
        clone.setPreComment( new String(preComment) );
        clone.setPostComment( new String(postComment) );
        clone.setEndLineComment( new String(endLineComment) );
        
        return clone;
    }
}
