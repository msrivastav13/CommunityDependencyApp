public inherited sharing class SessionHelper {
    public static String getSessionId() {
        return Test.isRunningTest()
            ? ''
            : Page.session.getContent().toString().trim();
    }
}
