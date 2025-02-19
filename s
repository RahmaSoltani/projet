plugins {
    id 'java'
    id("jacoco")
    id("com.github.spacialcircumstances.gradle-cucumber-reporting") version "0.1.25"
    id("org.sonarqube") version "4.4.0.3356"
    id ("maven-publish")
    id("io.github.oleksiiparf.slack-webhook") version "1.0.0"
    id("de.zebrajaeger.sendMail") version "0.2.2"
}

group = 'com.example'
version = '1.0'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'io.cucumber:cucumber-java:6.0.0'
    testImplementation 'io.cucumber:cucumber-junit:6.0.0'
    testImplementation 'junit:junit:4.12'
    implementation "org.aspectj:aspectjrt:1.9.21.1"
    implementation 'jakarta.mail:jakarta.mail-api:2.0.1'
    implementation 'com.sun.mail:jakarta.mail:2.0.1'



}
cucumberReports {
    outputDir = file('build/reports/cucumber')
    buildId = '0'
    reports = files('reports/example-report.json')
}

test {
    finalizedBy "jacocoTestReport",'sonar'

}
apply plugin: 'maven-publish'

group = 'com.example'
version = '0.1'

publishing {
    repositories {
        maven {

            url 'https://mymavenrepo.com/repo/wfeEoJVTqyCrSb3fpohC/'
            credentials {
                username 'myMavenRepo'
                password '12345678'
            }
        }
    }

    publications {
        maven(MavenPublication) {
            from components.java
        }
    }
}
slack {
    publishedPlugin {
        webHook = "https://hooks.slack.com/services/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"
        attachment {
            fallback = "New version successfully published."
            pretext = "New version successfully published."
            color = "good"
            field {
                title = "Module"
                value = project.name
                shortValue = true
            }
            field {
                title = "Version"
                value = project.version
                shortValue = true
            }
        }
        attachment {
            fallback = "Another line on sent together."
            pretext = "Another line on sent together."
            color = "good"
            field {
                title = "Something"
                value = "Something text"
            }
        }
    }
    buildSuccessful {
        webHook = "https://hooks.slack.com/services/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"
        attachment {
            fallback = "Project successfully built."
            pretext = "Project successfully built."
            field {
                title = "Module"
                value = project.name
                shortValue = true
            }
            field {
                title = "Version"
                value = project.version
                shortValue = true
            }
        }
    }

}

import jakarta.mail.Session
import jakarta.mail.Authenticator
import jakarta.mail.PasswordAuthentication
import jakarta.mail.Message
import jakarta.mail.MessagingException
import jakarta.mail.Transport
import jakarta.mail.internet.MimeMessage
import jakarta.mail.internet.InternetAddress


task sendMailCustom {
    doLast {
        // Configuration du serveur SMTP
        String smtpHost = "smtp.gmail.com"
        int smtpPort = 587
        String username = "lo_kaba@esi.dz"
        String password = "msvh ybei sfjf jjlb"

        // Paramètres de l'email
        String fromEmail = "lo_kaba@esi.dz"
        String toEmail = "lr_soltani@esi.dz"
        String emailSubject = "Notification Mail"
        String emailBody = "Hello!! this is the last update"

        Properties props = new Properties()
        props.put("mail.smtp.auth", "true")
        props.put("mail.smtp.starttls.enable", "true")
        props.put("mail.smtp.host", smtpHost)
        props.put("mail.smtp.port", smtpPort)

        // Authentification et création de session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password)
            }
        })

        try {
            // Création et envoi du message
            MimeMessage message = new MimeMessage(session)
            message.setFrom(new InternetAddress(fromEmail))
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail))
            message.setSubject(emailSubject)
            message.setText(emailBody)

            Transport.send(message)
            println("Email envoyé avec succès à : $toEmail")
        } catch (MessagingException e) {
            e.printStackTrace()
            println("Échec de l'envoi de l'email : ${e.message}")
        }
    }
}

sendMailCustom.mustRunAfter(publish)
postPublishedPluginToSlack.mustRunAfter(publish)
publish {
    finalizedBy "postPublishedPluginToSlack","sendMailCustom"

}
tasks.named('publish').configure {
    finalizedBy('test')
}

