let currentPage = 'main';

const main = document.getElementById('main');
const links = document.getElementById('links');
const projects = document.getElementById('projects');

document.addEventListener('DOMContentLoaded', function() {
    loadProjects();
    if (currentPage === 'main') {
        main.style.display = 'block';
        links.style.display = 'none';
        projects.style.display = 'none';
    } else if (currentPage === 'links') {
        links.style.display = 'block';
        main.style.display = 'none';
        projects.style.display = 'none';
    } else if (currentPage === 'projects') {
        projects.style.display = 'block';
        main.style.display = 'none';
        links.style.display = 'none';
    }
});

function changePage(page) {
    if (page === 'main') {
        main.style.display = 'block';
        links.style.display = 'none';
        projects.style.display = 'none';
    } else if (page === 'links') {
        links.style.display = 'block';
        main.style.display = 'none';
        projects.style.display = 'none';
    } else if (page === 'projects') {
        projects.style.display = 'block';
        links.style.display = 'none';
        main.style.display = 'none';
    }
}

function loadProjects() {
    fetch('https://api.github.com/search/repositories?q=user:justrals&sort=stars&order=desc')
        .then(response => response.json())
        .then(data => {
            const projectsContainer = document.getElementById('projects-container');
            
            projectsContainer.innerHTML = '';
            
            const originalProjects = data.items.filter(repo => !repo.fork);
            
            originalProjects.forEach(repo => {
                const projectCard = document.createElement('div');
                projectCard.className = 'project-card';

                projectCard.innerHTML = `
                    <div class="card-info">
                        <p class="project-title">${repo.name}</p>
                        <p class="project-desc">${repo.description || 'No description available'}</p>
                        <div class="repo-meta">
                            <div class="repo-meta-container"><img src="img/star.svg" class="repo-meta-img"> <p class="repo-meta-text">${repo.stargazers_count}</p></div>
                            <div class="repo-meta-container"><img src="img/fork.svg" class="repo-meta-img"> <p class="repo-meta-text">${repo.forks_count}</p></div>
                            <div class="repo-meta-container"><img src="img/calendar.svg" class="repo-meta-img"> <p class="repo-meta-text">${new Date(repo.updated_at).toLocaleDateString()}</p></div>
                        </div>
                        ${repo.language ? `
                        <div class="tags">
                            <p class="tag-badge gr-${repo.language.toLowerCase()}">${repo.language}</p>
                        </div>` : ''}
                        <div class="project-links-wrapper">
                            <a href="${repo.html_url}" target="_blank" class="project-link-wrapper gr-black"><img src="img/github-logo.svg" class="repo-meta-img"><p class="project-link">GitHub</p></a>
                            ${repo.homepage ? `<a href="${repo.homepage}" target="_blank" class="project-link-wrapper gr-purple"><p class="project-link">Webpage</p></a>` : ''}
                        </div>
                    </div>
                `;
                
                projectsContainer.appendChild(projectCard);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('projects-container').innerHTML = 
                '<p>Failed to load projects. Please try again later.</p>';
        });
}

function copyToClipboard(element, text) {
    navigator.clipboard.writeText(text).then(function() {
        const iElement = element.querySelector('i');
        if (iElement) {
            iElement.textContent = 'Copied!';
            setTimeout(() => {
                iElement.textContent = 'Click to copy';
            }, 2000);
        }
    }).catch(function(err) {
        console.error('Could not copy text: ', err);
    });
}
