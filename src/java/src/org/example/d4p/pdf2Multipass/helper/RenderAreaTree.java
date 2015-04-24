package org.example.d4p.pdf2Multipass.helper;

import jp.co.antenna.XfoJavaCtl.MessageListener;
import jp.co.antenna.XfoJavaCtl.XfoException;
import jp.co.antenna.XfoJavaCtl.XfoObj;

class ErrDump implements MessageListener {

  public void onMessage(int errLevel, int errCode, String errMessage) {
    System.out.println("ErrorLevel = " + errLevel + "\nErrorCode = " + errCode + "\n" + errMessage);
  }
}


public class RenderAreaTree {

  public static String ExecuteAxf(String inputFoFile, String outputAtFile) {
    XfoObj axfo = null;
    try {
      axfo = new XfoObj();
      ErrDump eDump = new ErrDump();
      axfo.setMessageListener(eDump);
      axfo.setDocumentURI(inputFoFile);
      axfo.setOutputFilePath(outputAtFile);
      axfo.setExitLevel(4);
      axfo.setPrinterName("@AreaTree");
      axfo.execute();
    } catch (XfoException e) {
      System.out.println("ErrorLevel = " + e.getErrorLevel() + "\nErrorCode = " + e.getErrorCode()
          + "\n" + e.getErrorMessage());
      return "XfoException: " + e.getMessage();
    } finally {
      try {
        if (axfo != null)
          axfo.releaseObjectEx();
      } catch (XfoException e) {
        System.out.println("ErrorLevel = " + e.getErrorLevel() + "\nErrorCode = "
            + e.getErrorCode() + "\n" + e.getErrorMessage());
        return "XfoException: " + e.getMessage();
      }
    }

    return "If you get this message, then that means there were no exceptions thrown by org.example.d4p.pdf2Multipass.helper.RenderAreaTree";

  }

}
