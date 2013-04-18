package com.bfuture.app.job.service;

import java.util.List;

public interface SmsJobManager {
      public void insupsql(final String sql);
      public List executeSql(final String sql);
      public void execessql(final String [] exesql);
}
