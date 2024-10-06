FROM docker.io/python:3.11.6

WORKDIR /workspace

# Install PDM and other essential tools
RUN pip install pdm

# Copy dependency files
COPY pyproject.toml README.md pdm.lock ./

# Install dependencies
ENV PATH="/workspace/.venv/bin:$PATH"
RUN pdm install --no-self
RUN pip install mistralai tensorboard torch

# Copy application code
COPY examples ./examples
COPY funsearch ./funsearch

# Install the application
RUN pip install --no-deps . && rm -r ./funsearch ./build

# Uncomment if needed - will instead be installed in the container when plotting commands are run
#RUN pip install pandas matplotlib
#RUN pip install llm-mistral

# Set Mistral API key
#CMD echo '{"mistral": "'$MISTRAL_API_KEY'"}' > $(llm keys path); /bin/bash
CMD /bin/bash