node { // Voert de pipeline uit op een Jenkins-agent

    stage('Preparation') { // Fase 1: voorbereiding

        catchError(buildResult: 'SUCCESS') {
            // Vangt fouten op zodat de pipeline kan verdergaan.
            // Het buildresultaat wordt op SUCCESS gezet.

            sh 'docker stop samplerunning'
            // Stopt de Docker-container met de naam samplerunning.

            sh 'docker rm samplerunning'
            // Verwijdert de gestopte Docker-container.
        }
    }

    stage('Build') { // Fase 2: applicatie bouwen

        build 'BuildSampleApp'
        // Start de Jenkins-job BuildSampleApp.
        // Jenkins wacht standaard tot deze job klaar is.
    }

    stage('Results') { // Fase 3: resultaten en tests

        build 'TestSampleApp'
        // Start de Jenkins-job TestSampleApp.
        // Deze job kan de applicatie testen en resultaten tonen.
    }
}
